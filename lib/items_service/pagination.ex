defmodule ItemsService.Pagination do
  @moduledoc """
  Page based pagination strategy
  """

  import Ecto.Query, warn: false

  @default_page "1"
  @default_size "500"

  @doc """
  Paginates a query by page and size.
  """
  def paginate(query, pagination) do
    page =
      pagination
      |> Map.get("page", @default_page)
      |> String.to_integer()

    size =
      pagination
      |> Map.get("size", @default_size)
      |> String.to_integer()

    do_paginate(query, page, size)
  end

  defp do_paginate(query, page, size) when page > 0 and size > 0 do
    offset = (page - 1) * size

    query
    |> limit(^size)
    |> offset(^offset)
  end

  defp do_paginate(query, _, _), do: limit(query, 0)
end
