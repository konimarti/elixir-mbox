# Mbox

Read and write mbox files. Works well in combination with
[elixir-mail](http://github.com/DockYard/elixir-mail).

Elixir fork of [go-mbox](http://www.github.com/emersion/go-mbox).

## Installation

```elixir
def deps do
  [
    # Get from hex
    {:mbox, "~> 0.1.0"}

    # Or from github
    {:mbox, github: "konimarti/elixir-mbox"}
  ]
end
```

## Usage

#### Parse mbox files

```elixir
{:ok, body} = File.read("path/to/mboxfile")
messages = Mbox.Parser.parse(body)
```

#### Render mbox files

```elixir
output = Mbox.Renderer.render(messages)
```

#### In combination with elixir-mail

```elixir


{:ok, body} = File.read("path/to/mboxfile")

mails =
body
|> Mbox.Parser.parse
|> Enum.map(&Mail.Parsers.RFC2822.parse/1)
```
