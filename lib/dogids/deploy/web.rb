require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def deploy_web
        print_heading("Deploying dogids.com")

        Net::SSH.start("web1.dogids.codelation.net", "dogids") do |ssh|
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

        print_heading("Done.")
      end
    end

  private

    def web_git_pull_command
      commands = []
      commands << "cd /home/dogids/apps/dogids.com"
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
