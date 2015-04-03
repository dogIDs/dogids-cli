require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_web
        print_heading("Deploying dogids.com...")

        Net::SSH.start("web1.dogids.codelation.net", "dogids") do |ssh|
          commands = []
          commands << "cd apps/dogids.com"
          commands << "git pull origin master"
          ssh.exec!(commands.join("&& ")) do |_channel, _stream, data|
            print_command(data)
          end
        end

        print_heading("Done.")
      end
    end
  end
end
