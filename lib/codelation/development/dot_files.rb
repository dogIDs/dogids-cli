require "thor"

module Codelation
  class Cli < Thor
  private

    # Install dot files and load them into ~/.bash_profile
    def install_dot_files
      copy_file "dot_files/.codelation.bash",     "~/.codelation.bash"
      copy_file "dot_files/.git-completion.bash", "~/.git-completion.bash"
      copy_file "dot_files/.git-prompt.sh",       "~/.git-prompt.sh"
      copy_file "dot_files/.jshintrc",            "~/.jshintrc"
      copy_file "dot_files/.rubocop.yml",         "~/.rubocop.yml"
      copy_file "dot_files/.scss-lint.yml",       "~/.scss-lint.yml"
    end
  end
end
