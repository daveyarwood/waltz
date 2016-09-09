#!/usr/bin/ruby

=begin
  This is a little Forth interpreter written in Ruby, for testing.

  The goal here is to implement the minimum viable interpreter that could
  successfully evaluate waltz.w (a Forth source file implementing the music
  theory lib), then evaluate user code that uses the library and gets the
  correct results.

  TODO:
  - implement : ... ; and other needed Forth features
  - move this Ruby implementation to its own project
  - provide an option to either use the built-in version of waltz.w or accept
    a file implementing another version of it -- can use this to provide test
    coverage for changes to the waltz library before releasing new versions
  - implement unit tests that use the Ruby Waltz interpreter with the current
    state of the library in this repo
=end

require 'readline'

class Forth
  attr_accessor :stack, :words

  def initialize
    @stack = []
    @words = {
      '+'    => -> { a, b = @stack.pop(2); @stack.push (a + b) },
      '*'    => -> { a, b = @stack.pop(2); @stack.push (a * b) },
      '-'    => -> { a, b = @stack.pop(2); @stack.push (a - b) },
      '/'    => -> { a, b = @stack.pop(2); @stack.push (a / b) },
      '='    => -> { a, b = @stack.pop(2); @stack.push (a == b) },
      '>'    => -> { a, b = @stack.pop(2); @stack.push (a > b) },
      '<'    => -> { a, b = @stack.pop(2); @stack.push (a < b) },
      'swap' => -> { a, b = @stack.pop(2); @stack.push b, a },
      'dup'  => -> { @stack.push @stack.last },
      'drop' => -> { @stack.pop },
      'over' => -> { @stack.push @stack[-2] },
      'dump' => -> { puts "stack: #{@stack.inspect}" },
      '.'    => -> { p @stack.pop }
    }
  end

  def eval input
    input.split.each do |word|
      builtin = @words[word]
      if builtin
        begin
          builtin.call
        rescue Exception => e
          p e
          break
        end
      else
        if /(0|[1-9]\d*)\.\d+/ =~ word
          @stack.push word.to_f
        elsif /0|[1-9]\d*/ =~ word
          @stack.push word.to_i
        else
          p RuntimeError.new "Unrecognized word: #{word}"
        end
      end
    end
  end
end

forth = Forth.new

if ARGV.count == 0
  while line = Readline.readline('forth> ', true)
    forth.eval(line)
  end
elsif ARGV.count == 1
  line = ARGV.first
  forth.eval(line)
else
  puts <<USAGE
Usage:
  #{__FILE__}
  #{__FILE__} 'string of Forth code'
USAGE
end
