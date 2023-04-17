defmodule CrawlexWeb.SiteLive do
  use CrawlexWeb, :live_view

  alias Crawlex.Sites

  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:id, params["id"] || "new")
     |> assign(
       :form,
       get_site(params["id"])
       |> Sites.change_site()
       |> to_form(as: "site")
     )}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={CrawlexWeb.Components.SiteForm} id={@id} form={@form} />
    """
  end

  defp get_site(nil),
    do: %Sites.Site{
      selectors: [
        %Sites.Site.Selector{name: "name"},
        %Sites.Site.Selector{name: "sku"},
        %Sites.Site.Selector{name: "price"},
        %Sites.Site.Selector{name: "brand"},
        %Sites.Site.Selector{name: "category"},
        %Sites.Site.Selector{name: "description"}
      ],
      wait_for_js: [],
      wait_for_selectors: []
    }

  defp get_site(id), do: Sites.get_site!(id)
end
