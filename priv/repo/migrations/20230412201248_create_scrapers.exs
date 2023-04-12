defmodule Crawlex.Repo.Migrations.CreateScrapers do
  use Ecto.Migration

  def change do
    create table(:scrapers) do
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
      add :clean_url, :string
      add :type, :string
      add :site_id, references(:sites, on_delete: :nothing)

      timestamps()
    end

    create index(:scrapers, [:site_id])
  end
end
