defmodule DNA do
  def encode_nucleotide(code_point) do
     case code_point do
       ?\s -> 0b0000
       ?A -> 0b0001
       ?C -> 0b0010
       ?G -> 0b0100
       ?T -> 0b1000
       _  -> raise "Invalid nucleotide"
     end
  end

  def decode_nucleotide(encoded_code) do
     case encoded_code do
       0b0000 -> ?\s
       0b0001 -> ?A
       0b0010 -> ?C
       0b0100 -> ?G
       0b1000 -> ?T
       _  -> raise "Invalid nucleotide"
     end
  end

  def encode(dna) do
    do_encode(dna, <<>>)
  end

  defp do_encode([], encoding), do: encoding
  defp do_encode(dna, encoding) do
    [current | rest] = dna
    encoded_nuc = <<encode_nucleotide(current)::4>>
    do_encode(rest, <<encoding::bitstring, encoded_nuc::bitstring>>)
  end

  def decode(dna) do
    do_decode(dna, [])
  end

  defp do_decode(<<>>, decoding), do: decoding
  defp do_decode(dna, decoding) do
    <<encoded_nuc::4, rest::bitstring>> = dna
    decoded_nuc = decode_nucleotide(encoded_nuc)
    do_decode(rest, decoding ++ [decoded_nuc])
  end
end
