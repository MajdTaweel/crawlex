defmodule CrawlexWeb.SiteLive do
  use CrawlexWeb, :live_view

  alias Crawlex.Sites

  def mount(%{"id" => id}, _session, socket) do
    site = Sites.get_site!(id)

    form =
      site
      |> Sites.change_site()
      |> to_form

    socket = assign(socket, %{site: site, form: form})

    {:ok, socket}
  end

  def handle_event("validate", %{"site" => params}, socket) do
    form =
      socket.assigns.site
      |> Sites.change_site(params)
      |> Map.put(:action, :update)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end

  def country_codes do
    Countries.all() |> Enum.map(&{:"#{&1.name}", &1.alpha2})
  end
end
