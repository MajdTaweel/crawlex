defmodule CrawlexWeb.SiteLive do
  use CrawlexWeb, :live_view

  alias Crawlex.Sites
  alias Crawlex.Sites.Site
  alias Crawlex.Sites.Site.Selector
  alias Crawlex.Sites.Site.Selector.ChildSelector

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
    do: %Site{
      selectors: [
        %Selector{name: "name"},
        %Selector{name: "sku"},
        %Selector{name: "price"},
        %Selector{name: "brand"},
        %Selector{name: "category"},
        %Selector{name: "description", attribute: "html"},
        %Selector{name: "color"},
        %Selector{
          name: "sizes",
          attribute: "children",
          children_selectors: [
            %ChildSelector{name: "name"},
            %ChildSelector{name: "quantity"}
          ]
        },
        %Selector{
          name: "images",
          attribute: "children",
          children_selectors: [
            %ChildSelector{
              name: "uri"
            }
          ]
        }
      ],
      wait_for_js: [],
      wait_for_selectors: []
    }

  defp get_site(id), do: Sites.get_site!(id)
end
