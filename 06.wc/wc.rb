#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(options)
  if ARGV[0] == nil # 標準出力
    input_text = $stdin.readlines
    display_array = []
    display_array << readlines(input_text)
  else # コマンドライン引数にファイルを指定
    display_array = input_file
  end

  display_array.each do |array|
    if options['l']
      ARGV[0] == nil ? (print array.first) : (print array.first + array.last)
    else
      array.each { |data| print data }
    end
    puts ""
  end
end

def readlines(input_text)
  array = [to_lines(input_text), to_words(input_text.join), to_bytesize(input_text.join)]
  array.map { |element| add_spaces(element) }
end

def input_file
  file_array = ARGV
  array_with_spaces =
    file_array.map do |file|
      text = File.read(file)
      array = [to_lines(text.lines), to_words(text), to_bytesize(text)]
      array.map { |element| add_spaces(element) }.push(" #{file}")
    end

  unless file_array[1] == nil # コマンドライン引数に複数ファイルを渡した場合
    to_total(file_array, array_with_spaces)
  end
  array_with_spaces
end

def to_total(file_array, array_with_spaces)
  total_lines = 0
  total_words = 0
  total_bytesize = 0
  file_array.each do |file|
    text = File.read(file)
    total_lines += to_lines(text.lines)
    total_words += to_words(text)
    total_bytesize += to_bytesize(text)
  end
  array = [total_lines, total_words, total_bytesize]
  total_array_with_spaces = array.map { |element| add_spaces(element) }.push(" total")
  array_with_spaces.push(total_array_with_spaces)
end

def to_lines(text)
  text.count
end

def to_words(text)
  text.split(/\s+/).count
end

def to_bytesize(text)
  text.bytesize
end

def add_spaces(display_element)
  display_element.to_s.rjust(8)
end

options = ARGV.getopts('l')
main(options)
