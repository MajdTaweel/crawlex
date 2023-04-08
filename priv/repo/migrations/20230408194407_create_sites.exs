defmodule Crawlex.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string
      add :base_url, :string

      timestamps()
    end

    create unique_index(:sites, [:base_url])
  end
end
