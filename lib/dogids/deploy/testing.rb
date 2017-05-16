require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_testing
        print_heading("Deploying backend to testing.dogids.com")

        server_addresses = [
          "testing"
        ]

        server_addresses.each do |server_address|
          ssh_address = get_config_url("staging","#{server_address}")
          next if ssh_address == false

          print_command("Server(#{server_address}): #{ssh_address}")

          Net::SSH.start(ssh_address, "dogids") do |ssh|
            print_command("Checking the current git status")
            ssh.exec!(backend_git_status_command) do |_channel, _stream, data|
              print_command(data)
            end

            current_branch = ssh.exec!("cd /home/dogids/apps/dogids-backend && git rev-parse --abbrev-ref HEAD").strip
            print_heading("Current Branch: #{current_branch}")

            branch = ask("-----> Which branch would you like to deploy? [#{current_branch}]").strip
            
            break print_command("Fine, be that way.") if branch.downcase == "cancel"
            
            branch = current_branch if branch.length == 0

            print_command("Pulling latest from #{branch}")
            ssh.exec!(backend_git_pull_command(branch)) do |_channel, _stream, data|
              print_command(data)
            end
            
            ssh.exec!(backend_composer_commands) do |_channel, _stream, data|
              print_command(data)
            end

            ssh.exec!(backend_deployment_commands) do |_channel, _stream, data|
              print_command(data)
            end
          end
        end

        print_heading("Done.")
      end
    end

  private

  end
end
