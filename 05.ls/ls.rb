#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

options = ARGV.getopts('a', 'l', 'r')

dir_files = options['a'] ? Dir.glob("*", File::FNM_DOTMATCH) : Dir.glob("*").sort
dir_files = dir_files.reverse if options['r']

def convert_to_filetype(ftype)
  {
    file: "-",
    directory: "d",
    characterSpecial: "c",
    blockSpecial: "b",
    fifo: "f",
    link: "l",
    socket: "s"
  }[ftype.to_sym]
end

def select_to_mode(mode)
  {
    "0": "---",
    "1": "--x",
    "2": "-w-",
    "3": "-wx",
    "4": "r--",
    "5": "r-x",
    "6": "rw-",
    "7": "rwx"
  }[mode.to_sym]
end

def l_option_data(file)
  stat = File::Stat.new(file)
  mode_number = sprintf("%o", stat.mode)
  data = []
  data << convert_to_filetype(stat.ftype) + select_to_mode(mode_number[-3]) + select_to_mode(mode_number[-2]) + select_to_mode(mode_number[-1])
  data << stat.nlink
  data << Etc.getpwuid(stat.uid).name
  data << Etc.getgrgid(stat.gid).name
  data << stat.size
  data << stat.mtime.strftime("%-m %e %k:%M")
  data << file 
end

if options['l']
  dir_files.each do |file|
    puts l_option_data(file).join('  ')
  end
end

unless options['l'] # オプションなし 
  slice_number = (dir_files.size % 3 == 0 ? dir_files.size / 3 : dir_files.size / 3 + 1)
  sliced_array = []
  dir_files.each_slice(slice_number) {|a| sliced_array << a }

  if sliced_array.last.size < slice_number
    (slice_number - sliced_array.last.size).times {sliced_array.last.push("")}
  end

  str_array_with_blank = []
  sliced_array.each do |str_array|
    max_string = str_array.max_by(&:size).size
    str_array_with_blank << str_array.each.map {|str| str + (" " * (max_string - str.size))}  
  end

  transposed_array = str_array_with_blank.transpose
  transposed_array.each {|display| puts display.join("    ")} 
end
