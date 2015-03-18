require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_development(vm_name = nil)
        if vm_name == "dev"
          puts "Running: ssh -R 52698:localhost:52698 dogids@55.55.55.20"
          exec("ssh -R 52698:localhost:52698 dogids@55.55.55.20")
        else
          ssh
        end
      end
    end
  end
end
