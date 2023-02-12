defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part(ast, acc) do
    case ast do
      {:def, _, [{_, _, nil} | _]}  -> {ast, ["" | acc]}
      {:defp, _, [{_, _, nil} | _]}  -> {ast, ["" | acc]}
      {:def, _, [{:when, _, [{func_atom, _, args} | _]} | _]}  -> {ast, [String.slice(Atom.to_string(func_atom), 0, length(args)) | acc]}
      {:defp, _, [{:when, _, [{func_atom, _, args} | _]} | _]}  -> {ast, [String.slice(Atom.to_string(func_atom), 0, length(args)) | acc]}
      {:def, _, [{func_atom, _, args} | _]}  -> {ast, [String.slice(Atom.to_string(func_atom), 0, length(args)) | acc]}
      {:defp, _, [{func_atom, _, args} | _]}  -> {ast, [String.slice(Atom.to_string(func_atom), 0, length(args)) | acc]}
      _ -> {ast, acc}
    end
  end

  def decode_secret_message(string) do
    ast = to_ast(string)
    {_ast, acc} = Macro.prewalk(ast, [], fn node, acc -> decode_secret_message_part(node, acc) end)
    acc |> Enum.reverse |> Enum.join
  end
end
