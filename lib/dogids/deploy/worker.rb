require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_worker
        print_heading("Deploying dogids-backgrounder...")

        Net::SSH.start("worker1.dogids.codelation.net", "dogids") do |ssh|
          commands = []
          commands << "cd apps/dogids-backgrounder"
          commands << "git pull origin master"
          ssh.exec!(commands.join("&& ")) do |_channel, _stream, data|
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
  end
end
