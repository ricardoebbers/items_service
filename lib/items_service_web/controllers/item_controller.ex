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
    render(conn, "index.json", %{data: items})
  end

  def get_by_id_or_names_path(conn, %{"id_or_names_path" => [id]}) do
    case Items.get_by_id_or_name(id) do
      nil -> {:error, :not_found}
      item -> render(conn, "show.json", %{data: item})
    end
  end

  def get_by_id_or_names_path(conn, %{"id_or_names_path" => names_path}) do
    case Items.get_by_names_path(names_path) do
      nil -> {:error, :not_found}
      item -> render(conn, "show.json", %{data: item})
    end
  end
end
