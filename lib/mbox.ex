defmodule Mbox do

  @header "From "
  @escaped_header ">" <> @header
  @crlf "\r\n"

  def header, do: @header
  def escaped_header, do: @escaped_header
  def crlf, do: @crlf

end
