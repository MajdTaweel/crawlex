defmodule Crawlex.ScrapersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crawlex.Scrapers` context.
  """

  alias Crawlex.SitesFixtures

  @doc """
  Generate a scraper.
  """
  def scraper_fixture(attrs \\ %{}) do
    %{id: site_id} = SitesFixtures.site_fixture()

    {:ok, scraper} =
      attrs
      |> Enum.into(%{
        brand: "some brand",
        category: "some category",
        colors: %{},
        description: "some description",
        images: "some images",
        name: "some name",
        price: "some price",
        site_id: site_id,
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
