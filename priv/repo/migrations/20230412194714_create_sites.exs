defmodule Crawlex.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :name, :string
      add :base_url, :string
      add :country_code, :string
      add :cookies, :map
      add :query_parameters, :map

      timestamps()
    end

    create unique_index(:sites, [:base_url])
  end
end
