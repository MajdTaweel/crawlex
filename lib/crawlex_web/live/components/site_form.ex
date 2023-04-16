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
          module={CrawlexWeb.Components.SelectorsForm}
          id="selectors-form-group"
          form={@form}
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

    form =
      site
      |> Sites.change_site(params)
      |> Map.put(:action, action(site.id))
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save", %{"site" => params}, socket) do
    site = socket.assigns.form.data

    case Sites.update_site(site, params) do
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

  defp action(nil), do: :insert
  defp action(_), do: :update
end
