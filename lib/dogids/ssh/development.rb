require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_development(vm_name = nil)
        if vm_name == "dev"
          ssh_address = get_config_url(vm_name)
          puts "Running: ssh -R 52698:localhost:52698 dogids@#{ssh_address}"
          exec("ssh -R 52698:localhost:52698 dogids@#{ssh_address}")
        else
          ssh
        end
      end
    end
  end
end
