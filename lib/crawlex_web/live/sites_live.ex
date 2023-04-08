defmodule CrawlexWeb.SitesLive do
  use CrawlexWeb, :live_view

  alias Crawlex.Sites

  def mount(_params, _session, socket) do
    socket = assign(socket, :sites, Sites.list_sites())
    {:ok, socket, temporary_assigns: [sites: []]}
  end
end
