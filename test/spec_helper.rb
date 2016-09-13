def with_out_str
  old_stdout = $stdout
  $stdout = StringIO.new('','w')
  yield
  $stdout.string
ensure
  $stdout = old_stdout
end

def expect_stdout waltz, code, result
  stdout = with_out_str do
    waltz.compile_and_run code
  end

  expect(stdout.chomp).to eq result
end
