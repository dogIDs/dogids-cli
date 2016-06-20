require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_production(vm_name = nil)
        case vm_name
        when "admin"
          ssh_address = get_config_url(vm_name)
          if ssh_address then
            puts "Running: `ssh -R 52698:localhost:52698 dogids@#{ssh_address}`"
            exec("ssh -R 52698:localhost:52698 dogids@#{ssh_address}")
          end
        when "db"
          ssh_address = get_config_url(vm_name)
          if ssh_address then
            puts "Running: `ssh -R 52698:localhost:52698 dogids@#{ssh_address}`"
            exec("ssh -R 52698:localhost:52698 dogids@#{ssh_address}")
          end
        when "web"
          ssh_address = get_config_url(vm_name)
          if ssh_address then
            puts "Running: `ssh -R 52698:localhost:52698 dogids@#{ssh_address}`"
            exec("ssh -R 52698:localhost:52698 dogids@#{ssh_address}")
          end
        when "worker"
          ssh_address = get_config_url(vm_name)
          if ssh_address then
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
