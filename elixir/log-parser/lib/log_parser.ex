defmodule LogParser do
  def valid_line?(line) do
    line =~ ~r/^\[DEBUG|INFO|WARN|ERROR\]/
  end

  def split_line(line) do
    String.split(line, ~r/<[~*=-]*>/)
  end

  def remove_artifacts(line) do
    String.replace(line, ~r/end-of-line[0-9]+/i, "")
  end

  def tag_with_user_name(line) do
    matches = Regex.run(~r/User\s+(\S*)/, line)
    line = if matches != nil do
      [_ | [name | _]] = matches
      "[USER] #{name} #{line}"
    else
      line
    end
    line
  end
end
