defmodule Username do
  def sanitize([]), do: []
  def sanitize(username) do
    [first | rest] = username
    # all characters but lowercase letters (97-122)
    # underscores (95)
    # and 4 german characters
    case first do
      first when first >= ?a and first <= ?z -> [first | sanitize(rest)]
      ?_ -> [first] ++ sanitize(rest)
      ?ä -> [?a, ?e] ++ sanitize(rest)
      ?ö -> [?o, ?e] ++ sanitize(rest)
      ?ü -> [?u, ?e] ++ sanitize(rest)
      ?ß -> [?s, ?s] ++ sanitize(rest)
      _ -> sanitize(rest)
    end
  end
end
