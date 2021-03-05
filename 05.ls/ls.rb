#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  if catch_l_option
    files.each do |file|
      puts l_option_data(file).join('  ')
    end
  else
    no_option
  end
end

def options
  ARGV.getopts('a', 'l', 'r')
end

def catch_l_option
  options['l']
end

def catch_a_option
  options['a']
end

def catch_r_option
  options['r']
end

def files
  files = catch_a_option ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*').sort
  catch_r_option ? files.reverse : files
end

def l_option_data(file)
  stat = File::Stat.new(file)
  mode_number = format('%o', stat.mode)
  data = []
  data << convert_to_filetype(stat.ftype) + convert_to_mode(mode_number[-3]) + convert_to_mode(mode_number[-2]) + convert_to_mode(mode_number[-1])
  data << stat.nlink
  data << Etc.getpwuid(stat.uid).name
  data << Etc.getgrgid(stat.gid).name
  data << stat.size
  data << stat.mtime.strftime('%-m %e %k:%M')
  data << file
end

def convert_to_filetype(ftype)
  {
    file: '-',
    directory: 'd',
    characterSpecial: 'c',
    blockSpecial: 'b',
    fifo: 'f',
    link: 'l',
    socket: 's'
  }[ftype.to_sym]
end

def convert_to_mode(mode)
  {
    '0': '---',
    '1': '--x',
    '2': '-w-',
    '3': '-wx',
    '4': 'r--',
    '5': 'r-x',
    '6': 'rw-',
    '7': 'rwx'
  }[mode.to_sym]
end

def no_option
  (slice_number - sliced_array.last.size).times { sliced_array.last.push('') } if sliced_array.last.size < slice_number
  transposed_array = str_array_with_blank.transpose
  transposed_array.each { |display| puts display.join('    ') }
end

def slice_number
  (files.size % 3).zero? ? files.size / 3 : files.size / 3 + 1
end

def sliced_array
  files.each_slice(slice_number).map { |sliced_array| sliced_array }
end

def str_array_with_blank
  sliced_array.map do |str_array|
    max_string = str_array.max_by(&:size).size
    str_array.each.map { |str| str + (' ' * (max_string - str.size)) }
  end
end

main
