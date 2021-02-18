#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = []
frames = []
scores.each do |s|
  if s == 'X' # strike
    shots << 10
  else
    shots << s.to_i
  end

  if shots.count == 1 && shots.first == 10
    frames << [10]
    shots = []
  elsif shots.count == 2
    frames << shots
    shots = []
  end
end

if frames.length == 11
  frames[9].concat(frames[10])
  frames.delete_at(10)
elsif frames.length == 12
  frames[9].concat(frames[10], frames[11])
  frames.delete_at(10)
  frames.delete_at(10)
end