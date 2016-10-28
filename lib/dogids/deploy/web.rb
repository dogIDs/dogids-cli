require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_web
        print_heading("Deploying dogids.com")

        server_addresses = [
          "web",
          "admin"
        ]

        server_addresses.each do |server_address|
          ssh_address = get_config_url("production","#{server_address}")
          next if ssh_address == false

          print_command("Server(#{server_address}): #{ssh_address}")

          Net::SSH.start(ssh_address, "dogids") do |ssh|
            print_command("Checking the current git status")
            ssh.exec!(web_git_status_command) do |_channel, _stream, data|
              print_command(data)
            end

            if yes?("-----> Continue with deployment? [no]")
              print_command("Pulling latest from master")
              ssh.exec!(web_git_pull_command) do |_channel, _stream, data|
                print_command(data)
              end

              print_command("Updating file permissions")
              ssh.exec!(web_update_permissions_command) do |_channel, _stream, data|
                print_command(data)
              end
            end
          end
        end

        print_heading("Done.")
        print_cloudflare_warning
      end
    end

  private

    def print_cloudflare_warning
      puts ""
      puts "================================================================================"
      puts "               DON'T FORGET TO PURGE THE CLOUDFLARE CACHE!"
      puts "             https://www.cloudflare.com/a/caching/dogids.com"
      puts "================================================================================"
      puts ""
    end

    def web_git_pull_command
      commands = []
      commands << "cd /home/dogids/apps/dogids.com"
      commands << "sudo chown dogids:dogids -R .git"
      commands << "sudo chown dogids:www-data -R blog/wp-content"
      commands << "sudo chown dogids:www-data -R resources"
      commands << "sudo chown dogids:www-data -R templates"
      commands << "git pull origin master"
      commands.join("&& ")
    end

    def web_git_status_command
      commands = []
      commands << "cd /home/dogids/apps/dogids.com"
      commands << "git status -s"
      commands.join("&& ")
    end

    def web_update_permissions_command
      commands = []
      app_path = "/home/dogids/apps/dogids.com"
      writable_directories = [
        "blog/wp-content",
        "feeds",
        "logs",
        "ls_file_cache",
        "resources",
        "reviews_cache",
        "temp",
        "templates",
        "uploaded"
      ]

      writable_directories.each do |directory|
        full_path = File.join(app_path, directory)
        commands << "sudo chown www-data:www-data -R #{full_path}"
        commands << "sudo chmod 775 -R #{full_path}"
      end

      commands.join("&& ")
    end
  end
end
