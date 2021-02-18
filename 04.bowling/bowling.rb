#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
frames = []
scores.each do |s|
  shots <<
    if s == 'X'
      10
    else
      s.to_i
    end

  if shots.count == 1 && shots.first == 10
    frames << [10]
    shots = []
  elsif shots.count == 2
    frames << shots
    shots = []
  end
end

case frames.length
when 11
  frames[9].concat(frames[10])
  frames.delete_at(10)
when 12
  frames[9].concat(frames[10], frames[11])
  frames.delete_at(10)
  frames.delete_at(10)
end
frames[9].concat(shots) unless shots.empty?

# ストライクとスペア時のボーナスポイントを追加して、フレームの合計を出す
point = 0
frames.each_with_index do |frame, idx|
  if frame == [10] && frames[idx + 1] == [10] && frames[idx + 2] == [10] # 3回連続ストライク
    point += 30
  elsif frame == [10] && frames[idx + 1] == [10] # 2回連続ストライク
    point += 20
    point += frames[idx + 2][0]
  elsif frame == [10] # 1回ストライク
    point += 10
    point += frames[idx + 1][0] + frames[idx + 1][1]
  elsif frame.sum == 10 && idx != 9 # スペア（10フレーム目以外）
    point += 10
    point += frames[idx + 1][0]
  else
    point += frame.sum
  end
end
puts point
