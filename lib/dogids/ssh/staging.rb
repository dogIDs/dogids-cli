require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def ssh_staging(vm_name = nil)
        if vm_name == "staging"
          puts "Running: ssh -R 52698:localhost:52698 dogids@staging.dogids.com"
          exec("ssh -R 52698:localhost:52698 dogids@staging.dogids.com")
        else
          ssh
        end
      end
    end
  end
end
