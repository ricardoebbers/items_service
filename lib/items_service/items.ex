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
  """
  def list_items(filters, sorting, pagination) do
    Item
    |> where(^filters)
    |> order_by(^sorting)
    |> Pagination.paginate(pagination)
    |> Repo.all()
  end

  @doc """
  Gets an item from its path hierarchy.
  """
  def get_by_names_path(names) do
    Item
    |> where(name: ^names)
    |> preload(:parent)
    |> select([i], %{i.name => i})
    |> Repo.all()
  end

  @doc """
  Gets a single item.
  """
  def get_by_id_or_name!(id_or_name) do
    Item
    |> where([i], i.id == ^id_or_name)
    |> or_where([i], i.name == ^id_or_name)
    |> Repo.one!()
  end

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
