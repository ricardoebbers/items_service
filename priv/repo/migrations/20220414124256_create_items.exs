defmodule ItemsService.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string
      add :priority, :integer
      add :parent_id, references(:items)

      timestamps()
    end

    create index(:items, [:parent_id])
  end
end
