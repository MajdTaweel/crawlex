defmodule Crawlex.Selectors.Selector do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "selectors" do
    field :brand, :string
    field :category, :string

    embeds_many :colors, Color, primary_key: false, on_replace: :delete do
      field :list, :string
      field :name, :string
      field :quantity, :string
      field :selected, :string
      field :action, :string
    end

    field :description, :string
    field :images, :string
    field :name, :string
    field :price, :string

    embeds_many :sizes, Size, primary_key: false, on_replace: :delete do
      field :list, :string
      field :name, :string
      field :quantity, :string
    end

    field :sku, :string
    field :type, :string

    field :wait_for_js, {:array, :string}
    field :wait_for_selectors, {:array, :string}

    belongs_to :site, Crawlex.Sites.Site

    timestamps()
  end

  @fields [
    :sku,
    :name,
    :images,
    :price,
    :brand,
    :description,
    :category,
    :type,
    :wait_for_js,
    :wait_for_selectors,
    :site_id
  ]
  @doc false
  def changeset(selector, attrs) do
    selector
    |> cast(attrs, @fields)
    |> cast_embed(:colors, with: &color_changeset/2)
    |> cast_embed(:sizes, with: &size_changeset/2)
    |> validate_required(@fields)
  end

  defp color_changeset(color, attrs) do
    color
    |> cast(attrs, [:list, :name, :quantity, :selected, :action])
  end

  defp size_changeset(size, attrs) do
    size
    |> cast(attrs, [:list, :name, :quantity])
  end
end
