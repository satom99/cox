defmodule Cox.Consumer do
  use Coxir.Commander
  use Cox.Commands

  def handle_event({:READY, _user}, state) do
    game = %{
      type: 0,
      name: "on Elixir"
    }
    Gateway.set_status("dnd", game)

    {:ok, state}
  end
end
