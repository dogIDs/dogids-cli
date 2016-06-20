require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_staging(vm_name = nil)
        if vm_name == "staging"
          ssh_address = get_config_url(vm_name)
          if ssh_address then
            puts "Running: ssh -R 52698:localhost:52698 dogids@#{ssh_address}"
            exec("ssh -R 52698:localhost:52698 dogids@#{ssh_address}")
          end
        else
          ssh
        end
      end
    end
  end
end
