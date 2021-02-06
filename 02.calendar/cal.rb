#!/usr/bin/env ruby

require 'date'
require 'optparse'

today = Date.today

# hオプションで今日の日付の色反転なし、mオプションで月、yオプションで年の指定
params = ARGV.getopts("h", "m:#{today.month}", "y:#{today.year}")
year = params["y"].to_i
month = params["m"].to_i

# 月の開始日と月の終了日
first_day = Date.new(year, month)
last_day = Date.new(year, month, -1)

# 今日の日付は色を反転させる
today_with_color = "\e[7m#{today.day.to_s.rjust(2)}\e[0m"

puts "#{month}月 #{year}".center(20)
array = ["日", "月", "火", "水", "木", "金", "土"]
puts array.join(" ")

# 月の開始日の前に曜日の数だけ空白を入れる
(first_day.wday * 3).times {print " "}

# 月の開始日から最終日までを表示させる
(first_day..last_day).each do |day|
  display_date =
    if day == today && !params["h"]
      today_with_color
    else
      day.day.to_s.rjust(2)
    end

  if day.saturday?
    print display_date + "\n"
  else
    print display_date + " "
  end
end
puts "\n"