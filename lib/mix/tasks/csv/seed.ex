defmodule Mix.Tasks.Csv.Seed do
  @moduledoc """
  Seed the database with data from a CSV file.

  The first argument is the path to the CSV file.

  The CSV file must have the following columns:
  - id: the id of the item
  - parent_id: the id of the parent. Can be nil.
  - item_name: the name of the item
  - priority: the priority of the item

  """
  use Mix.Task

  alias ItemsService.Items

  require Logger

  @shortdoc "Loads a csv in priv/repo and tries to create items with the data on it."
  @requirements ~w(ecto.drop ecto.create ecto.migrate app.config app.start)
  @columns ~w(id parent_id item_name priority)a

  @doc """
  test
  """
  @impl true
  def run([csv_file_path]) do
    success_count =
      csv_file_path
      |> Path.expand()
      |> File.stream!()
      |> Stream.drop(1)
      |> CSV.decode(headers: @columns)
      |> Stream.map(&map_to_attrs/1)
      |> Stream.map(&do_create/1)
      |> Enum.filter(&(&1 == :ok))
      |> length()

    Logger.info("Created #{success_count} items.")
  end

  defp map_to_attrs({:ok, row}) do
    Logger.debug("row: #{inspect(row)}")

    %{
      id: row[:id],
      name: row[:item_name],
      priority: row[:priority],
      parent_id: maybe_nil(row[:parent_id])
    }
  end

  defp map_to_attrs({:error, invalid_row}) do
    Logger.error("Invalid row: #{inspect(invalid_row)}")
    {:error, invalid_row}
  end

  defp maybe_nil(value) do
    if value == "nil", do: nil, else: value
  end

  defp do_create(attrs) when is_map(attrs) do
    case Items.create_item(attrs) do
      {:ok, _item} ->
        Logger.debug("Created item: #{inspect(attrs)}")
        :ok

      {:error, changeset} ->
        Logger.error("""
        Failed to create item: #{inspect(attrs)}.
        Errors: #{inspect(errors_on(changeset))}.
        """)

        :error
    end
  end

  defp do_create(_), do: nil

  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
