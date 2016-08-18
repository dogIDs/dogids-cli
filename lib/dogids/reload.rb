require "net/ssh"
require "thor"
module Dogids
  class Cli < Thor
    desc "reload", "Reloads the specified machine. Defaults to development"

    # Reload the specified environment
    # TODO add environments
    # @param [string] app_name
    def reload(app_name = nil)
      ssh_address = get_config_url("dev","dev")
      if yes?("-----> Reload development? [no]")
        reload_development_machine
        restart_lamp(ssh_address, "dogids")
      elsif yes?("-----> Restart LAMP stack? [no]")
        restart_lamp(ssh_address, "dogids")
      elsif yes?("-----> Restart LB and LAMP stack? [no]")
        restart_all
      elsif yes?("-----> Update Vagrant Box? (NOT RECOMMENDED) [no]")
        update_vagrant_box
      else
        say("Fine, I didn't want you to do anything anyway.")
      end
    end

    no_commands do

      # Upgrade local vagrant box (default is ubuntu/trusty64)
      def update_vagrant_box
        say("-----> Updating the vagrant box...","\e[32m")
        system("cd ~/dogids-vagrant && vagrant box update")
        system("cd ~/dogids-vagrant && vagrant box list")
        if yes?("-----> Remove old boxes? (NOT RECOMMENDED) [no]")
          system("cd ~/dogids-vagrant && vagrant box remove --all")
          system("cd ~/dogids-vagrant && vagrant box add ubuntu/trusty64")
        end
        reload_development_machine
      end

      # Reloads development machine
      def reload_development_machine
        say("-----> Reloading the development machine...","\e[32m")
        system("cd ~/dogids-vagrant && vagrant reload")
      end

      # Restarts HAProxy, Apache, HHVM, and MySQL
      def restart_all
        dev_machines = get_config_url("dev")
        dev_machines.each do |key,dev_machine|
          ssh_address = get_config_url("dev",dev_machine)
          restart_lamp(ssh_address, "dogids") if dev_machine == dev
          restart_lb(ssh_address, "dogids") if dev_machine == lb
        end
      end

      def restart_lamp(ssh_address,user)
        Net::SSH.start(ssh_address, "dogids") do |ssh|
          lamp_restart_command = "sudo service apache2 restart && sudo service hhvm restart && sudo service mysql restart"
          ssh.exec!(lamp_restart_command) do |_channel, _stream, data|
            print_command(data)
          end
        end
      end

      def restart_lb(ssh_address,user)
        Net::SSH.start(ssh_address, "dogids") do |ssh|
          lb_restart_command = "sudo service haproxy restart"
          ssh.exec!(lb_restart_command) do |_channel, _stream, data|
            print_command(data)
          end
        end
      end
    end
  end
end
