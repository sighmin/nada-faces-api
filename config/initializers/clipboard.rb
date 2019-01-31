module PB
  extend self

  def copy(input)
    IO.popen('pbcopy', 'w') { |f| f << input.to_s }
    nil
  end

  def paste
    `pbpaste`
    nil
  end
end
