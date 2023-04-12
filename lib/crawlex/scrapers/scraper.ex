defmodule Crawlex.Scrapers.Scraper do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "scrapers" do
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

    embeds_many :wait_for_js, WaitForJs, primary_key: false, on_replace: :delete do
      field :value, :string
    end

    embeds_many :wait_for_selectors, WaitForSelector, primary_key: false, on_replace: :delete do
      field :value, :string
    end

    belongs_to :site, Crawlex.Sites.Site

    timestamps()
  end

  @doc false
  def changeset(scraper, attrs) do
    scraper
    |> cast(attrs, [
      :sku,
      :name,
      :images,
      :price,
      :brand,
      :description,
      :category,
      :type
    ])
    |> cast_embed(:colors, with: &color_changeset/2)
    |> cast_embed(:sizes, with: &size_changeset/2)
    |> cast_embed(:wait_for_js, with: &wait_for_js_changeset/2)
    |> cast_embed(:wait_for_selectors, with: &wait_for_selector_changeset/2)
    |> validate_required([
      :sku,
      :name,
      :images,
      :price,
      :brand,
      :description,
      :category,
      :type
    ])
  end

  defp color_changeset(color, attrs) do
    color
    |> cast(attrs, [:list, :name, :quantity, :selected, :action])
  end

  defp size_changeset(size, attrs) do
    size
    |> cast(attrs, [:list, :name, :quantity])
  end

  defp wait_for_js_changeset(wait_for_js, attrs) do
    wait_for_js
    |> cast(attrs, [:value])
  end

  defp wait_for_selector_changeset(wait_for_selector, attrs) do
    wait_for_selector
    |> cast(attrs, [:value])
  end
end
