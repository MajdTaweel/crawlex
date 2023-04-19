defmodule Crawlex.Sites.SimpleSelector do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :name, :string
    field :selector, :string
    field :attribute, :string, default: "text"
  end

  def changeset(simple_selector, attrs) do
    simple_selector
    |> cast(attrs, [:name, :selector, :attribute])
    |> validate_required([:name, :selector])
  end
end
