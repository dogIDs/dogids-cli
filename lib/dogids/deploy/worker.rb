require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_worker
        print_heading("Deploying dogids-backgrounder...")

        Net::SSH.start("worker1.dogids.codelation.net", "dogids") do |ssh|
          print_command("Pulling latest from master...")
          ssh.exec!(worker_git_pull_command) do |_channel, _stream, data|
            print_command(data)
          end

          print_heading("Running bundle install...")
          ssh.exec!(worker_bundle_install_command) do |_channel, _stream, data|
            print_command(data)
          end

          if yes?("-----> Do you want to restart Sidekiq? [no]")
            command = "sudo restart dogids-backgrounder"
            ssh.exec!(command) do |_channel, _stream, data|
              print_command(data)
            end
          end
        end

        print_heading("Done.")
      end
    end

  private

    def worker_git_pull_command
      commands = []
      commands << "cd /home/dogids/apps/dogids-backgrounder"
      commands << "git pull origin master"
      commands.join("&& ")
    end

    def worker_bundle_install_command
      commands = []
      commands << "cd /home/dogids/apps/dogids-backgrounder"
      commands << "/home/dogids/ruby/bin/bundle install --deployment --without development test"
      commands.join("&& ")
    end
  end
end
