# frozen_string_literal: true

require './format'
require './process'
require './get_data'

def weather(input)
  operation = input[0]
  date = input[1]
  city = input[2].downcase

  case operation
  when '-e' then e(date, city)
  when '-a' then a(date, city)
  when '-c' then c(date, city)
  when '-cc' then cc(date, city)
  else puts 'Wrong operation'
  end
end

# 1. For a given year display the highest temperature and day, lowest temperature and day, most humid day and humidity.
# ruby weatherman.rb -e 2002 city_name
def e(year, city)
  path = lambda do
    if city == 'lahore'
      "./#{city}_weather/#{city}_weather_#{year}"
    else
      "./#{city.capitalize}_weather/#{city.capitalize}_weather_#{year}"
    end
  end
  data = yearly_data(path.call, city)

  # maximun temperature in the year
  max_temps = max_temps(data)
  highest = max_temps.max_by { |_k, v| v }
  highest_on_day = highest[0].split('-')[2]
  highest_in_month = highest[0].split('-')[1]
  puts "Highest: #{highest[1]}C on #{month_name(highest_in_month.to_i)} #{highest_on_day}"

  # minimun temperature in the year
  min_temps = min_temps(data)
  lowest = min_temps.min_by { |_k, v| v }
  lowest_on_day = lowest[0].split('-')[2]
  lowest_in_month = lowest[0].split('-')[1]
  puts "Lowest: #{lowest[1]}C on #{month_name(lowest_in_month.to_i)} #{lowest_on_day}"

  # most humid day in the year
  humidity = humidity(data)
  max_humid = humidity.max_by { |_k, v| v }
  max_humid_on_day = max_humid[0].split('-')[2]
  max_humid_in_month = max_humid[0].split('-')[1]
  puts "Humidity: #{max_humid[1]}% on #{month_name(max_humid_in_month.to_i)} #{max_humid_on_day}"
end

# 2. For a given month display the average highest temperature, average lowest temperature, average humidity.
# ruby weatherman.rb -a 2005/6 dubai
def a(date, city)
  data = format_data(date, city)
  highest_temps = highest_temps(data) - ['']
  puts "Highest Average: #{(highest_temps.reduce(0) { |sum, temp| sum + temp.to_i }) / highest_temps.length}C"

  lowest_temps = lowest_temps(data) - ['']
  puts "Lowest Average: #{(lowest_temps.reduce(0) { |sum, temp| sum + temp.to_i }) / lowest_temps.length}C"

  humidity = data['values'].map { |day| day.split(',')[data['heading'].index('Mean Humidity')] } - ['']
  puts "Average humidity: #{(humidity.reduce(0) { |sum, hum| sum + hum.to_i }) / humidity.length}%"
end

# 3. For a given month draw two horizontal bar charts on the console for the highest and lowest temperature on each day.
# ruby weatherman.rb -c 2011/03 dubai
def c(date, city)
  include Color

  data = format_data(date, city)
  year, month = date.split('/')
  puts "#{month_name(month.to_i)} #{year}"
  highest_temps = highest_temps(data)
  lowest_temps = lowest_temps(data)

  max_min_temps = highest_temps.zip(lowest_temps)
  day_coutner = 1
  max_min_temps.each do |temps|
    if temps[0].empty? || temps[1].empty?
      puts "#{day_coutner.to_s.rjust(2, '0')} Data not Available"
    else
      print "#{day_coutner.to_s.rjust(2, '0')} "
      temps[0].to_i.times { print '+'.red }
      puts " #{temps[0]}C"
      print "#{day_coutner.to_s.rjust(2, '0')} "
      temps[1].to_i.times { print '+'.blue }
      puts " #{temps[1]}C"
    end
    day_coutner += 1
  end
end

# 4. For a given month draw one horizontal bar chart on the console for the highest and lowest temperature.
# ruby weatherman.rb -cc 2011/3 dubai

def cc(date, city)
  include Color

  data = format_data(date, city)
  year, month = date.split('/')
  puts "#{month_name(month.to_i)} #{year}"
  highest_temps = highest_temps(data)
  lowest_temps = lowest_temps(data)

  max_min_temps = highest_temps.zip(lowest_temps)
  day_coutner = 1
  max_min_temps.each do |temps|
    if temps[0].empty?
      puts "#{day_coutner.to_s.rjust(2, '0')} Data not Available"
    else
      print "#{day_coutner.to_s.rjust(2, '0')} "
      temps[1].to_i.times { print '+'.blue }
      temps[0].to_i.times { print '+'.red }
      puts " #{temps[0]}C - #{temps[1]}C"
    end
    day_coutner += 1
  end
end

weather(ARGV)
