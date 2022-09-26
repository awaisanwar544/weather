# frozen_string_literal: true

def format_data(date, city)
  file_path = set_path(date, city)
  file_data = read_file(file_path, city)
  heading, *values = file_data
  { 'heading' => heading.split(',').map(&:strip), 'values' => values }
end

# module to colorize the text
module Color
  def red
    "\033[31m#{self}\033[0m"
  end

  def blue
    "\033[34m#{self}\033[0m"
  end
end
