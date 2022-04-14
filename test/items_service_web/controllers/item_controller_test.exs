defmodule ItemsServiceWeb.ItemControllerTest do
  use ItemsServiceWeb.ConnCase

  import ItemsFactory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists items", %{conn: conn} do
      %{id: id, name: name, priority: priority} = insert(:item)

      conn = get(conn, Routes.item_path(conn, :index))

      assert [
               %{
                 "attributes" => %{
                   "id" => ^id,
                   "name" => ^name,
                   "parent_id" => nil,
                   "priority" => ^priority
                 }
               }
             ] = json_response(conn, 200)["data"]
    end

    test "filter items", %{conn: conn} do
      _item_1 = %{id: id, name: name, priority: priority} = insert(:item)
      _item_2 = insert(:item)

      conn = get(conn, Routes.item_path(conn, :index), %{filter: %{name: name}})

      assert [
               %{
                 "attributes" => %{
                   "id" => ^id,
                   "name" => ^name,
                   "parent_id" => nil,
                   "priority" => ^priority
                 }
               }
             ] = json_response(conn, 200)["data"]
    end

    test "sort items", %{conn: conn} do
      item_1 = %{id: item_1_id, name: item_1_name} = insert(:item, priority: 1)
      _item_2 = %{id: item_2_id, name: item_2_name} = insert(:item, priority: 2, parent: item_1)

      conn = get(conn, Routes.item_path(conn, :index), %{sort: "-priority"})

      assert [
               %{
                 "attributes" => %{
                   "id" => ^item_2_id,
                   "name" => ^item_2_name,
                   "parent_id" => ^item_1_id,
                   "priority" => 2
                 }
               },
               %{
                 "attributes" => %{
                   "id" => ^item_1_id,
                   "name" => ^item_1_name,
                   "parent_id" => nil,
                   "priority" => 1
                 }
               }
             ] = json_response(conn, 200)["data"]
    end

    test "paginates items", %{conn: conn} do
      item_1 = %{id: item_1_id, name: item_1_name} = insert(:item, priority: 1)
      _item_2 = insert(:item, priority: 2, parent: item_1)

      conn = get(conn, Routes.item_path(conn, :index), %{page: %{size: 1, page: 1}})

      assert [
               %{
                 "attributes" => %{
                   "id" => ^item_1_id,
                   "name" => ^item_1_name,
                   "parent_id" => nil,
                   "priority" => 1
                 }
               }
             ] = json_response(conn, 200)["data"]
    end
  end
end
