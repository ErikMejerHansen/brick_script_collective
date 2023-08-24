defmodule BrickScriptCollective do
  @moduledoc """
  BrickScriptCollective keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias BrickScriptCollectiveWeb.Fruits
  alias BrickScriptCollectiveWeb.Colors

  def unique_name(),
    do:
      (Colors.random_color() <> " " <> Fruits.random_fruit())
      |> String.split(" ")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join()
end
