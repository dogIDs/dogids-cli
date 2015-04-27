require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_staging
        print_heading("Deploying dogids.com site to staging server")

        Net::SSH.start("staging.dogids.com", "dogids") do |ssh|
          print_command("Checking the current git status")
          ssh.exec!(staging_git_status_command) do |_channel, _stream, data|
            print_command(data)
          end

          current_branch = ssh.exec!("cd /home/dogids/apps/dogids.com && git rev-parse --abbrev-ref HEAD").strip

          print_heading("Current Branch: #{current_branch}")
          print_heading("Available Branches:")
          ssh.exec!("cd /home/dogids/apps/dogids.com && git branch -r --no-merged master") do |_channel, _stream, data|
            print_command("master")
            data.split("\n").each do |branch|
              print_command(branch.gsub("origin/", ""))
            end
          end

          branch = ask("-----> Which branch would you like to deploy?").strip
          return print_command("Fine, be that way.") if branch.length == 0

          print_command("Pulling latest from #{branch}")
          ssh.exec!(staging_git_pull_command(branch)) do |_channel, _stream, data|
            print_command(data)
          end

          print_command("Updating file permissions")
          ssh.exec!(web_update_permissions_command) do |_channel, _stream, data|
            print_command(data)
          end
        end

        print_heading("Done.")
      end
    end

  private

    def staging_git_pull_command(branch)
      commands = []
      commands << "cd /home/dogids/apps/dogids.com"
      commands << "git fetch origin #{branch}"
      commands << "git checkout #{branch}"
      commands << "git pull origin #{branch}"
      commands.join("&& ")
    end

    def staging_git_status_command
      commands = []
      commands << "cd /home/dogids/apps/dogids.com"
      commands << "git status -s"
      commands.join("&& ")
    end
  end
end
