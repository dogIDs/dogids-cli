require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_backend
        print_heading("Deploying backend to admin.dogids.com")

        server_addresses = [
          "admin"
        ]

        server_addresses.each do |server_address|
          ssh_address = get_config_url("production","#{server_address}")
          next if ssh_address == false

          print_command("Server(#{server_address}): #{ssh_address}")

          Net::SSH.start(ssh_address, "dogids") do |ssh|
            print_command("Checking the current git status")
            ssh.exec!(backend_git_status_command) do |_channel, _stream, data|
              print_command(data)
            end

            if yes?("-----> Continue with deployment? [no]")
              print_command("Pulling latest from master")
              ssh.exec!(backend_git_pull_command) do |_channel, _stream, data|
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
        end
        print_heading("Done.")
      end
    end

  private
  
    def backend_deployment_commands
      commands = []
      commands << "cd /home/dogids/apps/dogids-backend"
      commands << "php artisan deploy --progress"
      commands.join(" && ")
    end
    
    def backend_composer_commands
      commands = []
      commands << "cd /home/dogids/apps/dogids-backend"
      commands << "composer install --no-dev --optimize-autoloader"
      commands.join(" && ")
    end

    def backend_git_pull_command(branch = "master")
      commands = []
      commands << "cd /home/dogids/apps/dogids-backend"
      commands << "git fetch origin #{branch}"
      commands << "git checkout #{branch}"
      commands << "git pull origin #{branch}"
      commands.join(" && ")
    end
    
    def backend_git_status_command
      commands = []
      commands << "cd /home/dogids/apps/dogids-backend"
      commands << "git status -s"
      commands.join(" && ")
    end

  end
end
