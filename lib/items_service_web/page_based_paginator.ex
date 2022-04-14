defmodule ItemsServiceWeb.PageBasedPaginator do
  @moduledoc """
  Page based pagination strategy
  """

  alias ItemsService.Items

  @behaviour JSONAPI.Paginator

  @impl true
  def paginate(data, view, conn, page, _options) do
    number =
      page
      |> Map.get("page", "1")
      |> String.to_integer()

    size =
      page
      |> Map.get("size", "500")
      |> String.to_integer()

    total_pages = Items.total_pages(size)

    %{
      first: view.url_for_pagination(data, conn, Map.put(page, "page", "1")),
      last: view.url_for_pagination(data, conn, Map.put(page, "page", total_pages)),
      next: next_link(data, view, conn, number, size, total_pages),
      prev: previous_link(data, view, conn, number, size, total_pages)
    }
  end

  defp next_link(data, view, conn, page, size, total_pages)
       when page < total_pages,
       do: view.url_for_pagination(data, conn, %{size: size, page: page + 1})

  defp next_link(_data, _view, _conn, _page, _size, _total_pages), do: nil

  defp previous_link(data, view, conn, page, size, total_pages)
       when page > 1,
       do: view.url_for_pagination(data, conn, %{size: size, page: min(total_pages, page - 1)})

  defp previous_link(_data, _view, _conn, _page, _size, _total_pages), do: nil
end
