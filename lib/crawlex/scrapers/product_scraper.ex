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

    %Sites.Site{selectors: selectors, country_code: country_code} =
      Sites.get_site_by_url!(response.request.url)

    item = parse_selectors(document, selectors, %{}, country_code: country_code)

    Logger.info(item)

    %Crawly.ParsedItem{items: [item]}
  end

  defp parse_selectors(_, [], item, _), do: item

  defp parse_selectors(
         document,
         [selector | rest],
         item,
         opts
       ) do
    key = String.to_atom(selector.name)

    value =
      document
      |> parse(selector, opts)
      |> maybe_clean(key, opts)
      |> maybe_raw_html()

    item = Map.put(item, key, value)

    parse_selectors(document, rest, item, opts)
  end

  defp parse(document, %{attribute: "text", selector: selector}, _opts) do
    document
    |> Floki.find(selector)
    |> Floki.text()
    |> String.trim()
  end

  defp parse(document, %{attribute: "html", selector: selector}, _opts) do
    Floki.find(document, selector)
  end

  defp parse(document, %{attribute: "@" <> attribute, selector: selector}, _opts) do
    document
    |> Floki.find(selector)
    |> Floki.attribute(attribute)
    |> case do
      [] ->
        ""

      list ->
        list
        |> hd()
        |> String.trim()
    end
  end

  defp parse(
         document,
         %{
           attribute: "children",
           selector: selector,
           children_selectors: children_selectors
         },
         opts
       ) do
    document
    |> Floki.find(selector)
    |> Enum.map(fn item -> parse_selectors([item], children_selectors, %{}, opts) end)
  end

  defp maybe_clean(value, :sku, _opts), do: String.replace(value, ~r/["\(\)]/, "")

  defp maybe_clean(value, :price, country_code: country_code) do
    %{currency_code: currency_code} = Countries.get(country_code)

    value
    |> Money.parse!(currency_code)
    |> Money.to_decimal()
    |> Decimal.to_string()
  end

  defp maybe_clean(value, :description, _opts) do
    value
    |> Floki.filter_out("img")
    |> Floki.filter_out("a")
    |> Floki.filter_out("script")
    |> Floki.filter_out("audio")
    |> Floki.filter_out("video")
    |> Floki.filter_out("svg")
    |> Floki.traverse_and_update(fn {node, attrs, children} ->
      {
        node,
        Enum.reject(attrs, fn {attr_name, _value} ->
          attr_name in [
            "data-mce-style",
            "style",
            "class",
            "font-size",
            "size",
            "lang",
            "id",
            "href"
          ]
        end),
        children
      }
    end)
  end

  defp maybe_clean(value, _key, _opts), do: value

  defp maybe_raw_html(value) do
    case value do
      [%{}] -> value
      [%{} | _] -> value
      _ -> Floki.raw_html(value)
    end
  end
end
