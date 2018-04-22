defmodule Cox.Helpers do
  def admin?(user, _channel) do
    user.id in [
      "163801294002323458"
    ]
  end
end
