defmodule Crawlex.Repo.Migrations.CreateSelectors do
  use Ecto.Migration

  def change do
    create table(:selectors) do
      add :sku, :string
      add :name, :string
      add :images, :string
      add :colors, :map
      add :sizes, :map
      add :price, :string
      add :brand, :string
      add :description, :string
      add :category, :string
      add :wait_for_selectors, :map
      add :wait_for_js, :map
      add :type, :string
      add :site_id, references(:sites, on_delete: :nothing)

      timestamps()
    end

    create index(:selectors, [:site_id])
  end
end
