require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def cache_production(vm_name = nil)
        case vm_name
        when "category"
          print_heading("Checking the category reviews cache")
          Net::SSH.start("web2.dogids.codelation.net", "dogids") do |ssh|
            ssh.exec!(count_category_cache_files_production_command) do |_channel, _stream, data|
              print_command("Current category reviews: " + data)
            end
            if yes?("-----> Continue with clearing the cache? [no]")
              print_heading("Clearing the production category cache")
              ssh.exec!(clear_category_cache_production_command) do |_channel, _stream, data|
              end
            end
          end
        when "clear"
          print_heading("Let's start clearing the entire production cache")
          cache_production("category")
          cache_production("qa")
        when "qa"
          print_heading("Checking the product Q&A cache")
          Net::SSH.start("web2.dogids.codelation.net", "dogids") do |ssh|
            ssh.exec!(count_qa_cache_files_production_command) do |_channel, _stream, data|
              print_command("Current category reviews: " + data)
            end
            if yes?("-----> Continue with clearing this cache? [no]")
              print_heading("Clearing the production QA cache")
              ssh.exec!(clear_qa_cache_production_command) do |_channel, _stream, data|
              end
            end
          end
        else
          cache
        end
      end

      private

      def count_category_cache_files_production_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "find . -iname 'category*' | wc -l"
        commands.join("&& ")
      end

      def count_qa_cache_files_production_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "find . -iname 'turnto*' | wc -l"
        commands.join("&& ")
      end

      def clear_category_cache_production_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "sudo find . -type f -iname 'category*' -delete"
        commands.join("&&")
      end

      def clear_qa_cache_production_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "sudo find . -type f -iname 'turnto*' -delete"
        commands.join("&&")
      end
    end
  end
end
