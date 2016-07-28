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
      puts " Use the following format:"
      puts "  dogids cache:<environment> <machine> <action>"
      puts " "
      puts " Here are some basic examples:"
      puts " "
      puts "  dogids cache:dev dev clear               # Clear whole cache for the dogids.dev storefront"
      puts "  dogids cache:dev dev category            # Clear category cache for the dogids.dev storefront"
      puts "  dogids cache:dev dev css                 # Clear CSS cache for the dogids.dev storefront"
      puts "  dogids cache:dev dev javascript          # Clear Javascript cache for the dogids.dev storefront"
      puts "  dogids cache:dev dev qa                  # Clear Q&A cache for the dogids.dev storefront"
      puts " "
      puts "  dogids cache:staging staging clear       # Clear whole cache for the staging.dogids.com storefront"
      puts "  dogids cache:staging staging category    # Clear category cache for the staging.dogids.com storefront"
      puts "  dogids cache:staging staging css         # Clear CSS cache for the staging.dogids.com storefront"
      puts "  dogids cache:staging staging javascript  # Clear Javascript cache for the staging.dogids.com storefront"
      puts "  dogids cache:staging staging qa          # Clear Q&A cache for the staging.dogids.com storefront"
      puts " "
      puts "  dogids cache:production web clear        # Clear whole cache for the dogids.com storefront"
      puts "  dogids cache:production web category     # Clear category cache for the dogids.dev storefront"
      puts "  dogids cache:production web css          # Clear CSS cache for the production.dogids.com storefront"
      puts "  dogids cache:production web javascript   # Clear Javascript cache for the production.dogids.com storefront"
      puts "  dogids cache:production web qa           # Clear Q&A cache for the dogids.com storefront"
      puts " "
    end
  end
end
