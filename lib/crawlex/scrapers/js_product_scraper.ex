defmodule Crawlex.Scrapers.JSProductScraper do
  @moduledoc """
  This module is responsible for scraping e-commerce products by rendering a urls http content in the browser.
  """

  use Wallaby.DSL

  require Logger

  @timeout_in_milliseconds 5 * 60 * 1000

  def run(start_urls) do
    Task.async_stream(
      start_urls,
      fn url ->
        {:ok, session} = Wallaby.start_session()

        session
        |> visit(url)
        |> parse_item()
        |> Wallaby.end_session()
      end,
      timeout: @timeout_in_milliseconds
    )
    |> Stream.run()
  end

  def parse_item(session) do
    try do
      do_parse_item(session)
    rescue
      e -> Logger.error(e)
    end

    session
  end

  def do_parse_item(session) do
    item = %{
      name: text(session, Query.css(".ProductName"))
    }

    Logger.info(item)

    session
  end
end
