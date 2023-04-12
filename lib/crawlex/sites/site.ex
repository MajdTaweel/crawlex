defmodule Crawlex.Sites.Site do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "sites" do
    field :base_url, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:base_url, :name])
    |> validate_required([:base_url, :name])
    |> unique_constraint(:base_url)
  end
end
