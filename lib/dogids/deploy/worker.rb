require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_worker
        ssh_address = get_config_url("production","worker")
        return if ssh_address == false

        print_heading("Deploying dogids-backgrounder")

        Net::SSH.start("#{ssh_address}", "dogids") do |ssh|
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
      # Delete any SQL backups that failed to be deleted after uploading to S3
      commands << "sudo find /var/lib/docker/ -type f -name '*.sql' -delete"
      # Delete any old docker containers to free up space
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
