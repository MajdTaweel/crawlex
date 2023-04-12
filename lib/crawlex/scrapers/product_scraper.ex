defmodule Crawlex.Scrapers.ProductScraper do
  @moduledoc """
  This module is responsible for scraping e-commerce products.
  """
  use Crawly.Spider

  alias Crawlex.Scrapers.Scraper

  @impl Crawly.Spider
  def base_url, do: ""

  @impl Crawly.Spider
  def init, do: [start_urls: []]

  @impl Crawly.Spider
  def init(options: [scraper: %Scraper{}, start_urls: start_urls]) do
    [
      # start_urls: [
      #   "https://www.nisantasishoes.com/tr/nancy-acik-bej-mat-burun-metal-arka-bagli-kadin-topuklu-ayakkabi-11498"
      # ]
      start_urls: start_urls
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # Parse response body to document
    {:ok, document} = Floki.parse_document(response.body)

    item = %{
      sku: text(document, sku()) |> String.replace(~r"[\(\)]", ""),
      name: text(document, name())
    }

    Logger.info(item)

    item
  end

  def sku, do: "#divUrunKodu"

  def name, do: ".ProductName"

  defp text(document, selector) do
    document
    |> Floki.find(selector)
    |> Floki.text()
    |> String.trim()
  end
end
