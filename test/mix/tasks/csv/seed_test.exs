defmodule Mix.Tasks.Csv.SeedTest do
  use ItemsService.DataCase, async: true

  alias Mix.Tasks.Csv.Seed
  alias ItemsService.Items.Item
  alias ItemsService.Repo

  describe "run/1" do
    test "should create item given a csv file" do
      Seed.run(["test/mix/tasks/csv/seeds/well_formed_item.csv"])

      items = Repo.all(Item)
      assert [%Item{id: 3, parent_id: nil, name: "folder 1 1", priority: 4}] = items
    end

    test "should create item with parent" do
      Seed.run(["test/mix/tasks/csv/seeds/item_with_parent.csv"])

      items = Repo.all(Item)

      assert [
               %Item{id: 1, parent_id: nil, name: "folder 1 1", priority: 4},
               %Item{id: 2, parent_id: 1, name: "folder 1 2", priority: 99}
             ] = items
    end

    test "should not create items with errors" do
      Seed.run(["test/mix/tasks/csv/seeds/invalid_items.csv"])

      items = Repo.all(Item)

      assert [
               %Item{id: 1, parent_id: nil, name: "valid item", priority: 2}
             ] = items
    end
  end
end
