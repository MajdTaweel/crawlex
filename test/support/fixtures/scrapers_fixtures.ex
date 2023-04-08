defmodule Crawlex.ScrapersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crawlex.Scrapers` context.
  """

  @doc """
  Generate a unique scraper base_url.
  """
  def unique_scraper_base_url, do: "some base_url#{System.unique_integer([:positive])}"

  @doc """
  Generate a scraper.
  """
  def scraper_fixture(attrs \\ %{}) do
    {:ok, scraper} =
      attrs
      |> Enum.into(%{
        base_url: unique_scraper_base_url(),
        brand: "some brand",
        category: "some category",
        color: "some color",
        description: "some description",
        images: "some images",
        name: "some name",
        price: "some price",
        sizes: "some sizes",
        sku: "some sku",
        vendor: "some vendor"
      })
      |> Crawlex.Scrapers.create_scraper()

    scraper
  end
end
