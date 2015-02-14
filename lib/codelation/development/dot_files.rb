require "thor"

module Codelation
  class Cli < Thor
  private

    # Install dot files and load them into ~/.bash_profile
    def install_dot_files
      # Copy dot files to user's home directory
      copy_file "dot_files/.codelation.bash",     "~/.codelation.bash"
      copy_file "dot_files/.git-completion.bash", "~/.git-completion.bash"
      copy_file "dot_files/.git-prompt.sh",       "~/.git-prompt.sh"
      copy_file "dot_files/.jshintrc",            "~/.jshintrc"
      copy_file "dot_files/.rubocop.yml",         "~/.rubocop.yml"
      copy_file "dot_files/.scss-lint.yml",       "~/.scss-lint.yml"

      # Add `source ~/.codelation.bash` to ~/.bash_profile if it doesn't exist
      append_to_file "~/.bash_profile", "source ~/.codelation.bash"
    end
  end
end
