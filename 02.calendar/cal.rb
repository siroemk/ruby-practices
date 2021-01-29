require 'date'

today = Date.today
puts "#{today.month}月 #{today.year}".center(20)

array = ["日", "月", "火", "水", "木", "金", "土"]
puts array.join(' ')

first_day = Date.new(today.year, today.month)
last_day = Date.new(today.year, today.month, -1)

(first_day.wday * 3).times do
  print " "
end

(first_day..last_day).each do |day|
  if  day.saturday?
    print day.day.to_s.rjust(2) + "\n"
  elsif  day.day < 10
    print day.day.to_s.rjust(2) + " "
  else
    print day.day.to_s + " "
  end
end
puts "\n"