defmodule Mbox.Parser do
  import Mbox
  @moduledoc """
  Documentation for `Mbox.Parser`.
  """

  @header Mbox.header()

  @spec parse(binary()) :: []
  def parse(text)

  def parse([_ | _] = lines) do
    extract_messages(lines, [])
  end

  def parse(text),
    do: text |> String.split("\n", trim: false) |> parse


  defp extract_messages([], blocks) do
    blocks
    |> Enum.reverse
    |> IO.inspect
    |> Enum.map(&(Enum.join(&1, crlf())))
    |> IO.inspect
  end

  defp extract_messages([@header <> _ | tail], blocks) do
    extract_messages(tail, [[] | blocks])
  end

  defp extract_messages([head | tail], [block | blocks]) do
    extract_messages(tail, [block++[prepare_message(head)]|blocks])
  end


  defp prepare_message(message) when message != [] do
      message 
      |> String.replace_prefix(escaped_header(), @header)
  end
end
