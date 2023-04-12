defmodule Crawlex.ScrapersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crawlex.Scrapers` context.
  """

  @doc """
  Generate a scraper.
  """
  def scraper_fixture(attrs \\ %{}) do
    {:ok, scraper} =
      attrs
      |> Enum.into(%{
        brand: "some brand",
        category: "some category",
        clean_url: "some clean_url",
        colors: %{},
        description: "some description",
        images: "some images",
        name: "some name",
        price: "some price",
        sizes: %{},
        sku: "some sku",
        type: "some type",
        wait_for_js: %{},
        wait_for_selector: %{}
      })
      |> Crawlex.Scrapers.create_scraper()

    scraper
  end
end
