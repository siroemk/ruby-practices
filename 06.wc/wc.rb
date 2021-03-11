#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l')
file_array = ARGV

if ARGV[0] == nil
  input = $stdin.readlines
  print input.size.to_s.rjust(8)
  print input.join.split(/\s+/).count.to_s.rjust(8)
  puts input.join.bytesize.to_s.rjust(8)
end

total_lines = 0
total_words = 0
total_bytesize = 0

if options['l']
  file_array.each do |file|
    sentence = File.read(file)
    print sentence.lines.count.to_s.rjust(8)
    puts " #{file}"
      
    total_lines += sentence.lines.count
    total_words += sentence.split(/\s+/).count
    total_bytesize += sentence.bytesize
  end

  unless file_array[1] == nil
    print total_lines.to_s.rjust(8)
    puts " total"
  end
end

unless options['l']
  file_array.each do |file|
    sentence = File.read(file)
    print sentence.lines.count.to_s.rjust(8)
    print sentence.split(/\s+/).count.to_s.rjust(8)
    print sentence.bytesize.to_s.rjust(8) 
    puts " #{file}"
    
    total_lines += sentence.lines.count
    total_words += sentence.split(/\s+/).count
    total_bytesize += sentence.bytesize
  end

  unless file_array[1] == nil
    print total_lines.to_s.rjust(8)
    print total_words.to_s.rjust(8)
    print total_bytesize.to_s.rjust(8)
    puts " total"
  end
end
