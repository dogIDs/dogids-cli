require "net/ssh"
require "thor"

module Dogids
  class Cli < Thor
    no_commands do
      def cache_staging(vm_name = nil)
        case vm_name
        when "category"
          print_heading("Checking the category reviews cache")
          Net::SSH.start("staging.dogids.com", "dogids") do |ssh|
            ssh.exec!(count_category_cache_files_staging_command) do |_channel, _stream, data|
              print_command("Current category reviews: " + data)
            end
            if yes?("-----> Continue with clearing the cache? [no]")
              print_heading("Clearing the staging category cache")
              ssh.exec!(clear_category_cache_staging_command) do |_channel, _stream, data|
              end
            end
          end
        when "clear"
          print_heading("Let's start clearing the entire staging cache")
          cache_staging("category")
          cache_staging("qa")
        when "qa"
          print_heading("Checking the product Q&A cache")
          Net::SSH.start("staging.dogids.com", "dogids") do |ssh|
            ssh.exec!(count_qa_cache_files_staging_command) do |_channel, _stream, data|
              print_command("Current category reviews: " + data)
            end
            if yes?("-----> Continue with clearing this cache? [no]")
              print_heading("Clearing the staging QA cache")
              ssh.exec!(clear_qa_cache_staging_command) do |_channel, _stream, data|
              end
            end
          end
        else
          cache
        end
      end

      private

      def count_category_cache_files_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "find . -iname 'category*' | wc -l"
        commands.join("&& ")
      end

      def count_qa_cache_files_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "find . -iname 'turnto*' | wc -l"
        commands.join("&& ")
      end

      def clear_category_cache_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "sudo find . -type f -iname 'category*' -delete"
        commands.join("&&")
      end

      def clear_qa_cache_staging_command
        commands = []
        commands << "cd /home/dogids/apps/dogids.com/ls_file_cache"
        commands << "sudo find . -type f -iname 'turnto*' -delete"
        commands.join("&&")
      end
    end
  end
end
