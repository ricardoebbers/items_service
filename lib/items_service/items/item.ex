defmodule ItemsService.Items.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias ItemsService.Items.Item

  schema "items" do
    field :name, :string
    field :priority, :integer

    belongs_to :parent, Item
    has_many :children, Item, foreign_key: :parent_id

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:id, :name, :priority, :parent_id])
    |> validate_required([:name, :priority])
    |> validate_number(:id, greater_than: 0)
    |> validate_number(:priority, greater_than_or_equal_to: 0)
    |> unique_constraint(:id, name: :items_pkey)
    |> foreign_key_constraint(:parent_id)
  end
end
