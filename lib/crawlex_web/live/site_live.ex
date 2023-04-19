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
        %Sites.SimpleSelector{name: "name"},
        %Sites.SimpleSelector{name: "sku"},
        %Sites.SimpleSelector{name: "price"},
        %Sites.SimpleSelector{name: "brand"},
        %Sites.SimpleSelector{name: "category"},
        %Sites.SimpleSelector{name: "description"}
      ],
      wait_for_js: [],
      wait_for_selectors: []
    }

  defp get_site(id), do: Sites.get_site!(id)
end
