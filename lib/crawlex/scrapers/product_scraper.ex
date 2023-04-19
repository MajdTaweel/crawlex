defmodule Crawlex.Scrapers.ProductScraper do
  @moduledoc """
  This module is responsible for scraping e-commerce products by parsing the response from provided urls requests.
  """

  use Crawly.Spider

  alias Crawlex.Sites

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

    %{selectors: selectors} = Sites.get_site_by_url!(response.request.url)

    {:ok, item} = parse_selectors(document, selectors)

    Logger.info(item)

    %Crawly.ParsedItem{items: [item]}
  end

  defp parse_selectors(document, selectors, item \\ %{})
  defp parse_selectors(_, [], item), do: item

  defp parse_selectors(
         document,
         [%{name: name, selector: selector, attribute: attribute} | rest],
         item
       ) do
    key = String.to_atom(name)

    value =
      attribute
      |> parse(document, selector)
      |> maybe_clean_value(key)

    item = Map.put(item, key, value)

    {
      :ok,
      parse_selectors(
        document,
        rest,
        item
      )
    }
  end

  defp parse("text", document, selector) do
    document
    |> Floki.find(selector)
    |> Floki.text()
    |> String.trim()
  end

  defp maybe_clean_value(value, :sku) do
    String.replace(value, ~r"[\(\)]", "")
  end
end
