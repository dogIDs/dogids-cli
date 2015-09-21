require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_worker
        print_heading("Deploying dogids-backgrounder")

        Net::SSH.start("worker1.dogids.codelation.net", "dogids") do |ssh|
          print_command("Pulling latest from master")
          ssh.exec!(worker_git_pull_command) do |_channel, _stream, data|
            print_command(data)
          end

          print_heading("Building application")
          ssh.exec!(worker_build_command) do |_channel, _stream, data|
            print_command(data)
          end

          print_heading("Restarting")
          %w(clock web worker).each do |process|
            # First stop each process
            command = "sudo stop dogids-#{process}"
            ssh.exec!(command) do |_channel, _stream, data|
              print_command(data)
            end
            # Then start each process (restart doesn't work if not running)
            command = "sudo start dogids-#{process}"
            ssh.exec!(command) do |_channel, _stream, data|
              print_command(data)
            end
          end

          print_heading("Cleaning up")
          ssh.exec!(clean_up_command) do |_channel, _stream, data|
            print_command(data)
          end
        end

        print_heading("Done.")
      end
    end

  private

    def clean_up_command
      commands = []
      commands << "sudo find /var/lib/docker/ -type f -name '*.sql' -delete"
      commands << "sudo find /var/lib/docker/ -type f -name '*.log' -delete"
      commands << "sudo docker ps -a -f status=exited -q | xargs -r sudo docker rm -v"
      commands.join(" && ")
    end

    def worker_build_command
      commands = []
      commands << "cd /home/dogids/apps/dogids-backgrounder"
      commands << "git archive master | docker run -v /tmp/dogids-backgrounder-cache:/tmp/cache:rw -i -a stdin -a stderr -a stdout flynn/slugbuilder - > slug.tgz"
      commands.join("&& ")
    end

    def worker_git_pull_command
      commands = []
      commands << "cd /home/dogids/apps/dogids-backgrounder"
      commands << "git pull origin master"
      commands.join("&& ")
    end
  end
end
