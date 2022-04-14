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
    |> cast(attrs, [:name, :priority])
    |> validate_required([:name, :priority])
  end
end
