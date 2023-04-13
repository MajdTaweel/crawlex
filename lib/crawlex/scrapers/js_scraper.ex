defmodule Crawlex.Scrapers.JSScraper do
  @moduledoc """
  This module is responsible for scraping e-commerce products using browser rendering.
  """
  use Crawly.Spider

  alias Crawlex.Selectors

  @impl Crawly.Spider
  def base_url, do: ""

  @impl Crawly.Spider
  def init, do: [start_urls: []]

  @impl Crawly.Spider
  def init(kw) do
    start_urls = Keyword.get(kw, :start_urls)

    [
      start_urls: start_urls
    ]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    {:ok, document} = Floki.parse_document(response.body)

    %{sku: sku, name: name} = Selectors.get_selector_by_url!(response.request.url)

    item = %{
      sku: text(document, sku) |> String.replace(~r"[\(\)]", ""),
      name: text(document, name)
    }

    Logger.info(item)

    %Crawly.ParsedItem{items: [item]}
  end

  defp text(document, selector) do
    document
    |> Floki.find(selector)
    |> Floki.text()
    |> String.trim()
  end
end
