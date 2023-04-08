defmodule Crawlex.Sites.Site do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sites" do
    field :name, :string
    field :base_url, :string

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:name, :base_url])
    |> validate_required([:name, :base_url])
    |> unique_constraint(:base_url)
  end
end
