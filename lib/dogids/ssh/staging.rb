require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_staging(vm_name = nil)
        staging_machines = get_config_url("staging")
        if staging_machines.has_key?(vm_name)
          ssh_address = get_config_url("staging",vm_name)
          if vm_name == "lb"
            puts "Running: `ssh root@#{ssh_address}`"
            exec("ssh root@#{ssh_address}")
          else
            puts "Running: `ssh -R 52698:localhost:52698 dogids@#{ssh_address}`"
            exec("ssh -R 52698:localhost:52698 dogids@#{ssh_address}")
          end
        else
          ssh
        end
      end
    end
  end
end
