defmodule CrawlexWeb.SiteLive do
  use CrawlexWeb, :live_view

  alias Crawlex.Sites

  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:id, id)
     |> assign(
       :form,
       Sites.get_site!(id, true)
       |> Sites.change_site()
       |> to_form
     )}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={CrawlexWeb.Components.SiteForm} id={@id} form={@form} />
    """
  end
end
