defmodule CrawlexWeb.NewScraperLive do
  use CrawlexWeb, :live_view

  require Logger

  alias Crawlex.Scrapers
  alias Crawlex.Scrapers.Scraper

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(Scrapers.change_scraper(%Scraper{})))}
  end

  def handle_event("validate", %{"scraper" => scraper_params}, socket) do
    Logger.info(scraper_params)
    {:noreply, socket}
  end

  def handle_event("save", _, socket) do
    {:noreply, socket}
  end
end
