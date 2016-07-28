require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_dev(vm_name = nil)
        dev_machines = get_config_url("dev")
        if dev_machines.has_key?(vm_name)
          ssh_address = get_config_url("dev",vm_name)
          if vm_name == "lb"
            if yes?("----> Have you set up the dogIDs user for the development LB? [no]")
              puts "Running:  dogids@#{ssh_address}"
              exec("ssh dogids@#{ssh_address}")
            else
              puts "Running:  `cd ~/dogids-vagrant && vagrant ssh loadbalancer`"
              exec("cd ~/dogids-vagrant && vagrant ssh loadbalancer")
            end
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
