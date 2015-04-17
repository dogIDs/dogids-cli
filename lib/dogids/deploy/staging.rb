require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_staging
        print_heading("Deploying staging site...")

        Net::SSH.start("staging.dogids.com", "dogids") do |ssh|
          print_command("Checking the current git status...")
          ssh.exec!(web_git_status_command) do |_channel, _stream, data|
            print_command(data)
          end

          branch = ask("What branch would you like to deploy? [master]").strip
          branch = "master" unless branch.length > 0

          print_command("Pulling latest from #{branch}...")
          ssh.exec!(staging_git_pull_command(branch)) do |_channel, _stream, data|
            print_command(data)
          end

          print_command("Updating file permissions...")
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
  end
end
