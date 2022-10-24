defmodule Mbox.RendererTest do
  use ExUnit.Case, async: true

  @first_message """
                 From: herp.derp@example.com (Herp Derp)
                 Date: Thu, 01 Jan 2015 00:00:01 +0100
                 Subject: Test

                 This is a simple test.

                 And, by the way, this is how a "From" line is escaped in mboxo format:

                 From Herp Derp with love.

                 Bye.
                 """
                 |> String.replace("\n", "\r\n")
    

  test "render single message" do
    messages = render_message([@first_message], [from: "herp.derp@example.com", date: "Thu Jan  1 00:00:01 2015"])
    expected = 
      """
      From herp.derp@example.com Thu Jan  1 00:00:01 2015
      From: herp.derp@example.com (Herp Derp)
      Date: Thu, 01 Jan 2015 00:00:01 +0100
      Subject: Test

      This is a simple test.

      And, by the way, this is how a "From" line is escaped in mboxo format:

      >From Herp Derp with love.

      Bye.
      """

    assert hd(messages) == expected
  end

  defp render_message(message, opts),
    do: Mbox.Renderer.render(message, opts)
end
