require "thor"
require_relative "cache/staging"
require_relative "cache/production"
require_relative "cache/development"

module Dogids
  class Cli < Thor
    desc "cache", "List available cache commands"
    def cache(env_name = nil)
      puts " "
      puts "Cache Commands:"
      puts " "
      puts "  dogids cache:dev clear           # Clear whole cache for the dogids.dev storefront"
      puts "  dogids cache:dev category        # Clear category cache for the dogids.dev storefront"
      puts "  dogids cache:dev qa              # Clear Q&A cache for the dogids.dev storefront"
      puts " "
      puts "  dogids cache:staging clear       # Clear whole cache for the staging.dogids.com storefront"
      puts "  dogids cache:staging category    # Clear category cache for the dogids.dev storefront"
      puts "  dogids cache:staging qa          # Clear Q&A cache for the staging.dogids.com storefront"
      puts " "
      puts "  dogids cache:production clear    # Clear whole cache for the dogids.com storefront"
      puts "  dogids cache:production category # Clear category cache for the dogids.dev storefront"
      puts "  dogids cache:production qa       # Clear Q&A cache for the dogids.com storefront"
      puts " "
    end
  end
end
