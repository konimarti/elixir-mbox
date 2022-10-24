defmodule Mbox.Renderer do
  import Mbox
  @moduledoc """
  Documentation for `Mbox.Renderer`.
  """

  @header Mbox.header()

  def render(content, opts \\ [from: "???@???", date: "Thu Jan  1 00:00:01 2015"])

  def render([head | tail], opts) do
    [render(head, opts) | render(tail, opts)]
  end

  def render([], _opts) do
    []
  end

  def render(content, opts) when is_binary(content),
    do: content |> render_message(opts) 

  defp render_message(message, opts) when is_binary(message) do
      message 
      |> prepare_message
      |> add_separator(opts)
  end

  defp prepare_message(message) do
    message
      |> String.replace("\r\n","\n")
      |> String.split("\n", trim: false)
      |> Enum.map(&escape_line/1)
      |> Enum.join("\n")
  end

  defp escape_line(@header <> line) do
    escaped_header() <> line
  end
  defp escape_line(line), do: line

  defp add_separator(message, opts) do
    create_separator(opts) <> message
  end

  defp create_separator(opts) do
    "#{@header}#{opts[:from]} #{opts[:date]}\n"
  end

end
