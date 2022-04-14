defmodule ItemsService.ItemsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ItemsService.Items` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        name: "some name",
        priority: 42
      })
      |> ItemsService.Items.create_item()

    item
  end
end
