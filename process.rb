# frozen_string_literal: true

def highest_temps(data)
  data['values'].map { |day| day.split(',')[data['heading'].index('Max TemperatureC')] }
end

def lowest_temps(data)
  data['values'].map { |day| day.split(',')[data['heading'].index('Min TemperatureC')] }
end

# maximun temperature in the year
def max_temps(data)
  max_temps = {}
  data.each do |month|
    month.each do |day|
      arr = day.split(',')
      max_temps.store(arr[0], arr[1].to_i)
    end
  end
  max_temps
end

def min_temps(data)
  min_temps = {}
  data.each do |month|
    month.each do |day|
      arr = day.split(',')
      min_temps.store(arr[0], arr[3].to_i)
    end
  end
  min_temps
end

def humidity(data)
  humidity = {}
  data.each do |month|
    month.each do |day|
      arr = day.split(',')
      humidity.store(arr[0], arr[7].to_i)
    end
  end
  humidity
end
