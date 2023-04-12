defmodule Crawlex.Scrapers.Scraper do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  schema "scrapers" do
    field :base_url, :string
    field :brand, :string
    field :category, :string
    field :color, :string
    field :description, :string
    field :images, :string
    field :name, :string
    field :price, :string
    field :sizes, :string
    field :sku, :string
    field :vendor, :string

    timestamps()
  end

  @doc false
  def changeset(scraper, attrs) do
    scraper
    |> cast(attrs, [
      :base_url,
      :sku,
      :name,
      :images,
      :sizes,
      :price,
      :color,
      :brand,
      :description,
      :category,
      :vendor
    ])
    |> validate_required([
      :base_url,
      :sku,
      :name,
      :images,
      :sizes,
      :price,
      :color,
      :brand,
      :description,
      :category,
      :vendor
    ])
    |> unique_constraint(:base_url)
  end
end
