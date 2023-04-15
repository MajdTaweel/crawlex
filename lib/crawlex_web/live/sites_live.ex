defmodule CrawlexWeb.SitesLive do
  use CrawlexWeb, :live_view

  alias Crawlex.Sites

  def mount(_params, _session, socket) do
    socket = assign(socket, :sites, Sites.list_sites())
    {:ok, socket, temporary_assigns: [sites: []]}
  end

  def handle_event("view-or-edit", %{"site-id" => site_id}, socket) do
    socket = push_navigate(socket, to: ~p"/sites/#{site_id}")

    {:noreply, socket}
  end
end
