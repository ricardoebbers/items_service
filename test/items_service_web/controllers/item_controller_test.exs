defmodule ItemsServiceWeb.ItemControllerTest do
  use ItemsServiceWeb.ConnCase

  import ItemsFactory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index/2" do
    test "should lists items", %{conn: conn} do
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

    test "should filter items", %{conn: conn} do
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

    test "should sort items", %{conn: conn} do
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

    test "should paginate items", %{conn: conn} do
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

    test "should return empty list if page size is zero", %{conn: conn} do
      item_1 = %{id: item_1_id, name: item_1_name} = insert(:item, priority: 1)
      _item_2 = insert(:item, priority: 2, parent: item_1)

      conn = get(conn, Routes.item_path(conn, :index), %{page: %{size: 0, page: 1}})

      assert [] = json_response(conn, 200)["data"]
    end
  end

  describe "get_by_id_or_names_path/2" do
    test "should show an item given id", %{conn: conn} do
      %{id: id, name: name, priority: priority} = insert(:item)

      conn = get(conn, Routes.item_path(conn, :get_by_id_or_names_path, [Integer.to_string(id)]))

      assert %{
               "attributes" => %{
                 "id" => ^id,
                 "name" => ^name,
                 "parent_id" => nil,
                 "priority" => ^priority
               }
             } = json_response(conn, 200)["data"]
    end

    test "should show an item given it's name", %{conn: conn} do
      %{id: id, name: name, priority: priority} = insert(:item)

      conn = get(conn, Routes.item_path(conn, :get_by_id_or_names_path, [name]))

      assert %{
               "attributes" => %{
                 "id" => ^id,
                 "name" => ^name,
                 "parent_id" => nil,
                 "priority" => ^priority
               }
             } = json_response(conn, 200)["data"]
    end

    test "should show an item given it's path", %{conn: conn} do
      parent = %{id: parent_id, name: parent_name} = insert(:item)
      %{id: id, name: name, priority: priority} = insert(:item, parent: parent)

      conn = get(conn, Routes.item_path(conn, :get_by_id_or_names_path, [parent_name, name]))

      assert %{
               "attributes" => %{
                 "id" => ^id,
                 "name" => ^name,
                 "parent_id" => ^parent_id,
                 "priority" => ^priority
               }
             } = json_response(conn, 200)["data"]
    end

    test "should render 404 when given path doesn't exist", %{conn: conn} do
      parent = insert(:item)
      %{name: name} = insert(:item, parent: parent)

      conn = get(conn, Routes.item_path(conn, :get_by_id_or_names_path, ["foo", name]))

      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "should render 404 if item doesn't exist", %{conn: conn} do
      conn = get(conn, Routes.item_path(conn, :get_by_id_or_names_path, ["0"]))

      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end
  end
end
