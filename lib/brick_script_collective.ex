defmodule BrickScriptCollective do
  @moduledoc """
  BrickScriptCollective keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias BrickScriptCollectiveWeb.Fruits
  alias BrickScriptCollectiveWeb.Colors

  def unique_name_and_color() do
    {color_name, _} = Colors.random_color()

    user_name =
      (color_name <> " " <> Fruits.random_fruit())
      |> String.split(" ")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join()

    {user_name, color_name}
  end
end
