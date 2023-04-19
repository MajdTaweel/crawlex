defmodule CrawlexWeb.Components.SiteForm do
  @moduledoc """
  Simple form for site creation/edit.
  """

  use CrawlexWeb, :live_component

  alias Crawlex.Sites

  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
        <.input field={@form[:name]} label="Name" />
        <.input field={@form[:base_url]} label="Base URL" />
        <.input
          type="select"
          field={@form[:country_code]}
          label="Country Code"
          options={country_codes()}
        />

        <.live_component
          module={CrawlexWeb.Components.DynamicListForm}
          id="cookie-form-group"
          form={@form}
          key={:cookies}
          fields={[:name, :value, :domain]}
        />

        <.live_component
          module={CrawlexWeb.Components.DynamicListForm}
          id="query-parameters-form-group"
          form={@form}
          key={:query_parameters}
          fields={[:name, :value]}
        />

        <.live_component
          module={CrawlexWeb.Components.DynamicListForm}
          id="selectors-form-group"
          form={@form}
          key={:selectors}
          fields={[:name, :selector, :attribute]}
          polymorphic
        />

        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def handle_event("validate", %{"site" => params}, socket) do
    site = socket.assigns.form.data

    params =
      Map.put(
        params,
        "selectors",
        Enum.map(params["selectors"] || %{}, fn {_, v} -> v end)
      )

    form =
      site
      |> Sites.change_site(params)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", %{"site" => params}, socket) do
    site = socket.assigns.form.data

    params =
      params
      |> Map.put_new("cookies", [])
      |> Map.put_new("query_parameters", [])
      |> Map.put_new("selectors", [])

    case save_site(site, params) do
      {:ok, site} ->
        form =
          site
          |> Sites.change_site()
          |> to_form()

        {
          :noreply,
          socket
          |> assign(:form, form)
          |> put_flash(:info, "Site saved successfully.")
          |> push_navigate(to: ~p"/sites/#{site.id}")
        }

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp country_codes do
    Countries.all() |> Enum.map(&{:"#{&1.name}", &1.alpha2})
  end

  defp save_site(%{id: nil}, params), do: Sites.create_site(params)
  defp save_site(site, params), do: Sites.update_site(site, params)
end
