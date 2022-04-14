defmodule ItemsService.Items do
  @moduledoc """
  The Items context.
  """

  import Ecto.Query, warn: false
  alias ItemsService.Repo

  alias ItemsService.Items.Item
  alias ItemsService.Pagination

  @doc """
  Returns the list of items.

  The listing can be filtered, sorted and the results are paginated.
  """
  def list_items(filters, sorting, pagination) do
    Item
    |> where(^filters)
    |> order_by(^sorting)
    |> Pagination.paginate(pagination)
    |> Repo.all()
  end

  @doc """
  Gets an item given it's path.

  Given an item with name "a", and which parent's name is "b",
  the path of the item is ["b", "a"].
  """
  def get_by_names_path(names) do
    Item
    |> where([i], i.name in ^names)
    |> select([i], {i.name, i})
    |> preload(:parent)
    |> Repo.all()
    |> Map.new()
    |> last_child_or_null(names)
  end

  defp last_child_or_null(items, names) do
    Enum.reduce(names, fn child_name, parent_name ->
      child = Map.get(items, child_name)
      parent = Map.get(items, parent_name)

      parents_child_or_null(child, parent)
    end)
  end

  defp parents_child_or_null(child = %{parent_id: parent_id}, %{id: parent_id}), do: child
  defp parents_child_or_null(_, _), do: nil

  @doc """
  Gets a single item by name or id.

  Names aren't unique, so if there are multiple items with the same name,
  the first one is returned.
  """
  def get_by_id_or_name(id_or_name) do
    Item
    |> filter_by_id(id_or_name)
    |> or_filter_by_name(id_or_name)
    |> limit(1)
    |> preload(:parent)
    |> Repo.one()
  end

  defp filter_by_id(query, id_or_name) do
    case Integer.parse(id_or_name) do
      :error -> query
      {id, _} -> where(query, id: ^id)
    end
  end

  defp or_filter_by_name(query, id_or_name), do: or_where(query, name: ^id_or_name)

  @doc """
  Creates a item.
  """
  def create_item(attrs \\ %{}) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def total_pages(0), do: 0

  def total_pages(page_size) do
    Item
    |> Repo.aggregate(:count)
    |> Kernel./(page_size)
    |> ceil()
  end
end
