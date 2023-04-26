defmodule CrawlexWeb.Components.SelectorsListFrom do
  @moduledoc """
  Dynamic nested list form for site selectors.
  """

  use CrawlexWeb, :live_component

  alias Crawlex.Sites
  alias Ecto.Changeset

  def mount(socket) do
    {:ok, socket}
  end

  @fields ~w(name selector attribute)a
  def update(assigns, socket) do
    socket =
      socket
      |> assign(
        key: :selectors,
        form: assigns.form,
        fields: @fields
      )
      |> assign_selectors_with_children(assigns)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex justify-between">
        <h1 class="font-bold">Selectors</h1>
        <.button type="button" title="Add New" phx-click="add-new" phx-target={@myself}>
          <.icon name="hero-plus" />
        </.button>
      </div>

      <div class="flex flex-col py-4 gap-4">
        <.inputs_for :let={group} field={@form[:selectors]}>
          <div class="flex gap-x-2">
            <%= for field <- @fields do %>
              <.input
                field={group[field]}
                label={title_from_atom(field)}
                phx-keyup={field == :attribute && "attribute-changed"}
                phx-target={@myself}
                phx-value-index={group.index}
              />
            <% end %>

            <.button
              type="button"
              class="self-start mt-[34px] bg-red-500 hover:bg-red-400"
              title="Remove"
              phx-click="remove"
              phx-value-index={group.index}
              phx-target={@myself}
            >
              <.icon name="hero-minus-circle" />
            </.button>
          </div>

          <%= if group.index in @selectors_with_children do %>
            <div class="mt-6 p-4 bg-gray-200 rounded">
              <div class="flex justify-between">
                <h1 class="font-bold">Children Selectors</h1>
                <.button
                  type="button"
                  title="Add child"
                  phx-click="add-new-child"
                  phx-value-index={group.index}
                  phx-target={@myself}
                >
                  <.icon name="hero-plus" />
                </.button>
              </div>
              <div class="flex flex-col gap-y-4 py-4 ml-4">
                <.inputs_for :let={nested_group} field={group[:children_selectors]}>
                  <div class="flex gap-x-2">
                    <%= for field <- @fields do %>
                      <.input field={nested_group[field]} label={title_from_atom(field)} />
                    <% end %>

                    <.button
                      type="button"
                      class="self-start mt-[34px] bg-red-500 hover:bg-red-400"
                      title="Remove"
                      phx-click="remove-child"
                      phx-value-parent-index={group.index}
                      phx-value-index={nested_group.index}
                      phx-target={@myself}
                    >
                      <.icon name="hero-minus-circle" />
                    </.button>
                  </div>
                </.inputs_for>
              </div>
            </div>
          <% end %>
        </.inputs_for>
      </div>
    </div>
    """
  end

  def handle_event("add-new-child", %{"index" => index}, socket) do
    changeset = socket.assigns.form.source

    selectors =
      changeset
      |> Changeset.get_field(:selectors)
      |> List.update_at(
        String.to_integer(index),
        fn %Sites.Site.Selector{children_selectors: children_selectors} = selector ->
          %Sites.Site.Selector{
            selector
            | children_selectors:
                (children_selectors || []) ++ [%Sites.Site.Selector.ChildSelector{}]
          }
        end
      )

    form =
      changeset
      |> Changeset.put_change(:selectors, selectors)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("remove-child", %{"parent-index" => parent_index, "index" => index}, socket) do
    changeset = socket.assigns.form.source

    selectors =
      changeset
      |> Changeset.get_field(:selectors)
      |> List.update_at(
        String.to_integer(parent_index),
        fn %Sites.Site.Selector{children_selectors: children_selectors} = selector ->
          %Sites.Site.Selector{
            selector
            | children_selectors:
                List.delete_at(
                  children_selectors,
                  String.to_integer(index)
                )
          }
        end
      )

    form =
      changeset
      |> Changeset.put_change(:selectors, selectors)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("attribute-changed", %{"index" => index, "value" => value}, socket) do
    {:noreply, assign_selectors_with_children(socket, String.to_integer(index), value)}
  end

  defdelegate handle_event(event, params, socket),
    to: CrawlexWeb.Live.Helpers,
    as: :handle_dynamic_list_form_event

  defp assign_selectors_with_children(socket, assigns) do
    selectors =
      socket.assigns[:selectors_with_children] ||
        assigns.form.data.selectors
        |> Enum.with_index(fn selector, index ->
          {"#{index}", Map.from_struct(selector)}
        end)
        |> Enum.filter(fn
          {_key, %{"attribute" => attribute}} -> attribute == "children"
          {_key, %{attribute: attribute}} -> attribute == "children"
        end)
        |> Enum.map(fn {key, _value} -> String.to_integer(key) end)
        |> MapSet.new()

    assign(socket, :selectors_with_children, selectors)
  end

  defp assign_selectors_with_children(socket, index, value) do
    selectors = socket.assigns.selectors_with_children

    selectors =
      if value == "children" do
        MapSet.put(selectors, index)
      else
        MapSet.delete(selectors, index)
      end

    assign(socket, :selectors_with_children, selectors)
  end
end
