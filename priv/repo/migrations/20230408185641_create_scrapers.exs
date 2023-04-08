defmodule Crawlex.Repo.Migrations.CreateScrapers do
  use Ecto.Migration

  def change do
    create table(:scrapers) do
      add :base_url, :string
      add :sku, :string
      add :name, :string
      add :images, :string
      add :sizes, :string
      add :price, :string
      add :color, :string
      add :brand, :string
      add :description, :string
      add :category, :string
      add :vendor, :string

      timestamps()
    end

    create unique_index(:scrapers, [:base_url])
  end
end
