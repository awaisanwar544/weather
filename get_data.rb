# frozen_string_literal: true

def read_file(path, city)
  raise StandardError, 'Data not found' unless File.file?(path)

  file_data = File.readlines(path)
  if city == 'lahore'
    _before, heading, *values, _extra = file_data
    values.unshift(heading)
  else
    file_data
  end
end

def month_name(number)
  raise StandardError, 'Invalid entry for month' unless number <= 12 && number.positive?

  months = { 1 => 'January', 2 => 'Febrary', 3 => 'March', 4 => 'April', 5 => 'May', 6 => 'June', 7 => 'July',
             8 => 'August', 9 => 'September', 10 => 'October', 11 => 'November', 12 => 'December' }
  months[number]
end

def set_path(date, city)
  year, month = date.split('/')
  if city == 'lahore'
    "./#{city}_weather/#{city}_weather_#{year}_#{month_name(month.to_i)[0..2]}.txt"
  else
    "./#{city.capitalize}_weather/#{city.capitalize}_weather_#{year}_#{month_name(month.to_i)[0..2]}.txt"
  end
end

def yearly_data(path, city)
  data = []
  12.times do |index|
    _headings, *values = read_file("#{path}_#{month_name((index + 1).to_i)[0..2]}.txt", city)
    data << values
  end
  data
end
