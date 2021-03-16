#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main(options)
  files_array = ARGV
  output_array = files_array.first.nil? ? input_no_file(input_text: $stdin.readlines) : input_any_files(files_array)

  output_array.each do |array|
    if options['l']
      display_lines = array.first
      display_total = array.last
      files_array.first.nil? ? (print display_lines) : (print display_lines + display_total)
    else
      array.each { |display_all_data| print display_all_data }
    end
    puts ''
  end
end

def input_no_file(input_text:)
  output_array = [to_lines(input_text), to_words(input_text.join), to_bytesize(input_text.join)]
  [add_spaces(output_array)]
end

def input_any_files(files_array)
  output_array_with_spaces =
    files_array.map do |file|
      text = File.read(file)
      array = [to_lines(text.lines), to_words(text), to_bytesize(text)]
      add_spaces(array).push(" #{file}")
    end

  to_total(files_array, output_array_with_spaces) unless files_array[1].nil? # 引数に複数ファイルを渡した場合、配列の最後にtotalの結果を入れる
  output_array_with_spaces
end

def to_total(files_array, output_array_with_spaces)
  total_lines = 0
  total_words = 0
  total_bytesize = 0
  files_array.each do |file|
    text = File.read(file)
    total_lines += to_lines(text.lines)
    total_words += to_words(text)
    total_bytesize += to_bytesize(text)
  end
  total_array = [total_lines, total_words, total_bytesize]
  total_array_with_spaces = add_spaces(total_array).push(' total')
  output_array_with_spaces.push(total_array_with_spaces)
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

def add_spaces(array)
  space_size = 8
  array.map { |element| element.to_s.rjust(space_size) }
end

options = ARGV.getopts('l')
main(options)
