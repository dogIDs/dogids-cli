require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_production(vm_name = nil)
        case vm_name
        when "db"
          puts "Running: `ssh -R 52698:localhost:52698 dogids@db1.dogids.codelation.net`"
          exec("ssh -R 52698:localhost:52698 dogids@db1.dogids.codelation.net")
        when "web"
          puts "Running: `ssh -R 52698:localhost:52698 dogids@web1.dogids.codelation.net`"
          exec("ssh -R 52698:localhost:52698 dogids@web1.dogids.codelation.net")
        when "worker"
          puts "Running: `ssh -R 52698:localhost:52698 dogids@worker1.dogids.codelation.net`"
          exec("ssh -R 52698:localhost:52698 dogids@worker1.dogids.codelation.net")
        else
          ssh
        end
      end
    end
  end
end
