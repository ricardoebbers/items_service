defmodule ItemsServiceWeb.ItemController do
  use ItemsServiceWeb, :controller

  alias ItemsService.Items

  action_fallback ItemsServiceWeb.FallbackController

  plug JSONAPI.QueryParser,
    filter: ~w(name),
    sort: ~w(priority),
    view: PostView

  def index(
        conn = %{assigns: %{jsonapi_query: %{filter: filters, sort: sorting, page: pagination}}},
        _params
      ) do
    items = Items.list_items(filters, sorting, pagination)
    render(conn, "index.json", %{data: items, meta: "foo"})
  end

  def get_by_id_or_names_path(conn, %{"names_path" => [id_or_name]}) do
    item = Items.get_by_id_or_name!(id_or_name)
    render(conn, "show.json", item: item)
  end

  def get_by_id_or_names_path(conn, %{"names_path" => names_path}) do
    item = Items.get_by_names_path(names_path)
    render(conn, "show.json", item: item)
  end
end
