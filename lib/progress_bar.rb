class ProgressBar
  def initialize (title, total, out = STDERR)
    @title = title
    @total = total
    @out = out
    @terminal_width = 80
    @bar_mark = "|"
    @current = 0
    @previous = 0
    @finished_p = false
    @start_time = Time.now
    @previous_time = @start_time
    @title_width = 0
    @format = "%-#{@title_width}s %3d%% %s %s"
    @format_arguments = [:title, :percentage, :bar, :stat]
    clear
    show
    if block_given?
      yield(self)
      finish
    end
  end

  def fmt_title
    "      "
  end
end
