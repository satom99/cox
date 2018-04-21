defmodule Cox.Helpers do
  def admin?(member) do
    member.user.id in [
      "163801294002323458"
    ]
  end
end
