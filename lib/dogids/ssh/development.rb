require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_development(vm_name = nil)
        case vm_name
        when "db"
          puts "Running: ssh -R 52698:localhost:52698 dogids@55.55.55.10"
          exec("ssh -R 52698:localhost:52698 dogids@55.55.55.10")
        when "web"
          puts "Running: ssh -R 52698:localhost:52698 dogids@55.55.55.20"
          exec("ssh -R 52698:localhost:52698 dogids@55.55.55.20")
        when "worker"
          puts "Running: ssh -R 52698:localhost:52698 dogids@55.55.55.30"
          exec("ssh -R 52698:localhost:52698 dogids@55.55.55.30")
        else
          ssh
        end
      end
    end
  end
end
