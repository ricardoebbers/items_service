defmodule ItemsFactory do
  use ExMachina.Ecto, repo: ItemsService.Repo

  alias ItemsService.Items.Item

  def item_factory do
    %Item{
      name: sequence(:name, &"Item name #{&1}"),
      priority: sequence(:priority, & &1),
      parent_id: nil
    }
  end
end
