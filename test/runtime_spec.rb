require 'waltz'
require_relative 'spec_helper'

# TODO: rewrite these tests in Waltz, provide minimal Ruby runner

describe 'the runtime environment' do
  before(:each) do
    @waltz = Waltz.new
  end

  it 'should put numbers on the stack' do
    @waltz.compile_and_run '2'
    expect(@waltz.runtime_stack).to eq [2]

    @waltz.compile_and_run '45 -7'
    expect(@waltz.runtime_stack).to eq [2, 45, -7]
  end

  it 'should pop and print on .' do
    expect_stdout @waltz, '2 3 4 5 .', '5'
  end

  it 'should dump the stack to STDOUT on ..' do
    expect_stdout @waltz, '2 3 4 5 ..', 'stack: [2, 3, 4, 5]'
  end

  it 'should do math operations + - * /' do
    expect_stdout @waltz, '100 150 + .', '250'
    expect_stdout @waltz, '67 60 - .', '7'
    expect_stdout @waltz, '9 10 * .', '90'
    expect_stdout @waltz, '9 10 * 10 * .', '900'
    expect_stdout @waltz, '42 2 / .', '21'
  end

  it 'should do comparison operators = < >' do
    expect_stdout @waltz, '2 2 = .', 'true'
    expect_stdout @waltz, '2 -2 = .', 'false'
    expect_stdout @waltz, '200 5 > .', 'true'
    expect_stdout @waltz, '200 5 < .', 'false'
  end

  it 'should support swap, dup, drop, over' do
    expect_stdout @waltz, '5 dup ..', 'stack: [5, 5]'
    expect_stdout @waltz, '1 2 swap ..', 'stack: [5, 5, 2, 1]'
    expect_stdout @waltz, 'drop drop drop ..', 'stack: [5]'
    expect_stdout @waltz, '4 3 over ..', 'stack: [5, 4, 3, 4]'
  end

  it 'should support defining new words with : and ;' do
    @waltz.compile_and_run ': negate 0 swap - ;'
    expect_stdout @waltz, '42 negate .', '-42'
  end

  it 'should throw an error upon use of an undefined word' do
    expect {
      @waltz.compile_and_run '2 dup swap drop scuppernong'
    }.to raise_error RuntimeError
  end

  it 'should throw an error if : is encountered between : and ;' do
    expect {
      @waltz.compile_and_run ': frobnicate 5 : 7 ;'
    }.to raise_error RuntimeError
  end

  it 'should throw an error if ; is encountered before :' do
    expect {
      @waltz.compile_and_run '42 dup swap ; :'
    }.to raise_error RuntimeError
  end
end
