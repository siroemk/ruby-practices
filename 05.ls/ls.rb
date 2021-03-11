#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main(options)
  files = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
  files = files.reverse if options['r']

  if options['l']
    blocks = files.sum { |file| blocks(file) }
    puts "total #{blocks}"
    files.each { |file| puts l_option_data(file).join('  ') }
  else
    no_option_data(files).each { |display| puts display.join('    ') }
  end
end

def stat(file)
  File::Stat.new(file)
end

def blocks(file)
  stat(file).blocks
end

def l_option_data(file)
  mode_number = format('%o', stat(file).mode)
  data = []
  data << to_filetype_character(stat(file).ftype) + to_mode_character(mode_number[-3]) + to_mode_character(mode_number[-2]) + to_mode_character(mode_number[-1])
  data << stat(file).nlink
  data << Etc.getpwuid(stat(file).uid).name
  data << Etc.getgrgid(stat(file).gid).name
  data << stat(file).size
  data << stat(file).mtime.strftime('%-m %e %k:%M')
  data << file
end

def to_filetype_character(ftype)
  {
    file: '-',
    directory: 'd',
    link: 'l'
  }[ftype.to_sym]
end

def to_mode_character(mode)
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

def no_option_data(files)
  # 3列表示のためにeach_sliceで、3つの要素をもつ配列を作る。
  slice_number = (files.size % 3).zero? ? files.size / 3 : files.size / 3 + 1
  sliced_array = files.each_slice(slice_number).to_a

  # transposeメソッドを使いたいので、配列内の要素の数を揃える。要素が足りない配列に空文字追加する。
  third_array = sliced_array.last
  (slice_number - third_array.size).times { third_array.push('') } if third_array.size < slice_number

  # 3列表示で文字を揃えたいので配列の中で一番長い文字列を基準に、空白を追加する。
  array_with_blank =
    sliced_array.map do |str_array|
      max_string = str_array.max_by(&:size).size
      str_array.map { |str| str + (' ' * (max_string - str.size)) }
    end
  array_with_blank.transpose
end

options = ARGV.getopts('a', 'l', 'r')
main(options)
