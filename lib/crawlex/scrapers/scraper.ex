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
    |> validate_and_trim_base_url()
    |> unique_constraint(:base_url)
  end

  defp validate_and_trim_base_url(scraper) do
    base_url = get_field(scraper, :base_url)
    maybe_validate_and_trim_base_url(scraper, base_url)
  end

  def maybe_validate_and_trim_base_url(scraper, nil), do: scraper

  def maybe_validate_and_trim_base_url(scraper, base_url) do
    case URI.new(base_url) do
      {:ok, %{host: host, scheme: scheme}} when not is_nil(host) and not is_nil(scheme) ->
        base_url = "#{scheme}://#{String.trim(host, "/")}"

        put_change(scraper, :base_url, base_url)

      {:error, part} ->
        add_error(scraper, :base_url, part)

      _ ->
        add_error(scraper, :base_url, "Invalid URL")
    end
  end
end
