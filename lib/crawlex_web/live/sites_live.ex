defmodule CrawlexWeb.SitesLive do
  use CrawlexWeb, :live_view

  alias Crawlex.Sites

  def mount(_params, _session, socket) do
    socket = assign(socket, :sites, Sites.list_sites())
    {:ok, socket, temporary_assigns: [sites: []]}
  end

  def render(assigns) do
    ~H"""
    <.header>
      Sites
      <:actions>
        <.link title="Create New Site" href={~p"/sites/new"}>
          <.icon name="hero-plus" />
        </.link>
      </:actions>
    </.header>

    <.table id="sites-table" rows={@sites}>
      <:col :let={site} label="ID"><%= site.id %></:col>
      <:col :let={site} label="Name"><%= site.name %></:col>
      <:col :let={site} label="Base URL"><%= site.base_url %></:col>
      <:col :let={site} label="Country Code"><%= site.country_code %></:col>
      <:col :let={site} label="">
        <.button title="View/Edit" phx-value-site-id={site.id} phx-click="view-or-edit">
          <.icon name="hero-adjustments-horizontal" />
        </.button>

        <.button
          title="Delete"
          phx-value-site-id={site.id}
          phx-value-site-name={site.name}
          phx-click="delete"
        >
          <.icon name="hero-trash" />
        </.button>
      </:col>
    </.table>
    """
  end

  def handle_event("view-or-edit", %{"site-id" => site_id}, socket) do
    socket = push_navigate(socket, to: ~p"/sites/#{site_id}")

    {:noreply, socket}
  end

  def handle_event("delete", %{"site-id" => site_id, "site-name" => site_name}, socket) do
    Sites.delete_site(%Sites.Site{id: String.to_integer(site_id)})

    socket =
      socket
      |> assign(:sites, Sites.list_sites())
      |> put_flash(:info, "Site \"#{site_name}\" deleted successfully.")

    {:noreply, socket}
  end
end
