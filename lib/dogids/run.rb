require "net/ssh"
require "thor"
module Dogids
  class Cli < Thor
    desc "dev", "Runs the development environment for the backend"

    # Run the development site
    # @param [string] app_name
    def dev(app_name = nil)
      system("cd ~/dogids-backend/themes/dogids && npm run dev")
    end

    # no_commands do
    # end
  end
end
