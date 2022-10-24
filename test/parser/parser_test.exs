defmodule Mbox.ParserTest do
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
    

  test "parse single message" do
    messages =
      parse_mbox(
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
      )

    # IO.inspect(messages)
    assert hd(messages) == @first_message
  end

  test "parse two messages" do
    messages =
      parse_mbox(
        """
        From herp.derp@example.com Thu Jan  1 00:00:01 2015
        From: herp.derp@example.com (Herp Derp)
        Date: Thu, 01 Jan 2015 00:00:01 +0100
        Subject: Test

        This is a simple test.

        And, by the way, this is how a "From" line is escaped in mboxo format:

        >From Herp Derp with love.

        Bye.

        From herp.derp@example.com Thu Jan  1 00:00:01 2015
        From: herp.derp@example.com (Herp Derp)
        Date: Thu, 01 Jan 2015 00:00:01 +0100
        Subject: Test

        This is a simple test.

        And, by the way, this is how a "From" line is escaped in mboxo format:

        >From Herp Derp with love.

        Bye.
        """
      )

    [first, second] = messages
    assert first == @first_message
    assert second == @first_message
  end

  defp parse_mbox(message),
    do: message |> Mbox.Parser.parse()
end
