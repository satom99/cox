defmodule Cox.Commands do
  use Coxir.Commander
  import Cox.Helpers

  @prefix "|>"

  @permit &admin?/1
  command info do
    project = Coxir.Mixfile.project()
    version = project[:version]
    name = project[:name]

    count = fn struct ->
      struct
      |> apply(:select, [])
      |> length
    end

    voice = Voice
    |> Supervisor.count_children
    |> Map.get(:active)

    embed = %{
      title: "Information",
      color: 0x900C3F,
      footer: %{
        text: "#{name}-#{version} on Elixir #{System.version()}"
      },
      fields: [
        %{
          name: "Users",
          value: count.(User),
          inline: true
        },
        %{
          name: "Guilds",
          value: count.(Guild),
          inline: true
        },
        %{
          name: "Members",
          value: count.(Member),
          inline: true
        },
        %{
          name: "Channels",
          value: count.(Channel),
          inline: true
        },
        %{
          name: "Messages",
          value: count.(Message),
          inline: true
        },
        %{
          name: "Voice",
          value: voice,
          inline: true
        }
      ]
    }
    Message.reply(message, %{embed: embed})
  end

  @permit &admin?/1
  command eval(string) do
    binding = [
      user: User.get(),
      channel: channel,
      message: message
    ]

    result = \
    try do
      string
      |> Code.eval_string(binding, __ENV__)
      |> elem(0)
    rescue
      error -> error
    end

    Message.reply(
      message,
      """
      ```elixir
      #{inspect result}
      ```
      """
    )
    |> case do
      %{error: error} ->
        Message.reply(
          message,
          """
          ```elixir
          #{inspect error}
          ```
          """
        )
      _success -> :ok
    end
  end

  @space :voice
  @permit &admin?/1
  command join do
    member.voice
    |> Voice.join
  end

  @space :voice
  @permit &admin?/1
  command leave do
    member.voice
    |> Voice.leave
  end

  @space :voice
  @permit &admin?/1
  command play(term) do
    message
    |> join

    member.voice
    |> Voice.play(term)
  end

  @space :voice
  @permit &admin?/1
  command stop do
    member.voice
    |> Voice.stop_playing
  end

  @space :cookie
  command eat do
    mention = "<@#{author.id}>"
    content = "here, have a :cookie: #{mention}"
    Message.reply(message, content)
  end
end
