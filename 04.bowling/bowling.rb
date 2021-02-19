#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')

shots = []
frames = []
scores.each do |s|
  shots << (s == 'X' ? 10 : s.to_i)

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
  frames[9].concat(frames[10].pop(2))
when 12
  frames[9].concat(frames[10].pop(1), frames[11].pop(1))
end
frames[9].concat(shots) unless shots.empty?
frames.delete_if(&:empty?)

# ストライクとスペア時のボーナスポイントを追加して、フレームの合計を出す
point =
  frames.each_with_index.sum do |frame, idx|
    if frame == [10] && frames[idx + 1] == [10] && frames[idx + 2] == [10] # 3回連続ストライク
      30
    elsif frame == [10] && frames[idx + 1] == [10] # 2回連続ストライク
      20 + frames[idx + 2][0]
    elsif frame == [10] # 1回ストライク
      10 + frames[idx + 1][0] + frames[idx + 1][1]
    elsif frame.sum == 10 && idx != 9 # スペア（10フレーム目以外）
      10 + frames[idx + 1][0]
    else
      frame.sum
    end
  end
puts point
