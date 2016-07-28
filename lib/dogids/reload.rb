require "thor"
module Dogids
  class Cli < Thor
    desc "reload", "Reloads the specified machine. Defaults to development"

    # Reload the specified environment
    # TODO add environments
    # @param [string] app_name
    def reload(app_name = nil)
      if yes?("-----> Reload development? [no]")
        reload_development_machine
      else
        update_vagrant_box if yes?("-----> Update Vagrant Box? (NOT RECOMMENDED) [no]")
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

    end
  end
end
