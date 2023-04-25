defmodule CrawlexWeb.Components.SelectorsListFrom do
  @moduledoc """
  Dynamic nested list form for site selectors.
  """

  use CrawlexWeb.Components.DynamicListEvents

  alias Crawlex.Sites
  alias Ecto.Changeset

  def mount(socket) do
    {:ok, socket}
  end

  @fields ~w(name selector attribute)a
  def update(assigns, socket) do
    {:ok,
     assign(
       socket,
       key: :selectors,
       form: assigns.form,
       selectors_with_children:
         assigns[:selectors_with_children] ||
           selectors_with_children(assigns, assigns.form.data.selectors),
       fields: @fields
     )}
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
                phx-change={field == :attribute && "attribute-changed"}
                phx-target={@myself}
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

  def handle_event("attribute-changed", %{"site" => %{"selectors" => selectors}}, socket) do
    {:noreply,
     assign(socket, :selectors_with_children, selectors_with_children(socket.assigns, selectors))}
  end

  defp selectors_with_children(assigns, [%Sites.Site.Selector{} | _rest] = selectors) do
    selectors =
      Enum.with_index(selectors, fn selector, index -> {"#{index}", Map.from_struct(selector)} end)

    get_selectors_with_children(assigns, selectors)
  end

  defp selectors_with_children(assigns, selectors),
    do: get_selectors_with_children(assigns, selectors)

  defp get_selectors_with_children(assigns, selectors) do
    filter_with_children = fn
      {_key, %{"attribute" => attribute}} -> attribute == "children"
      {_key, %{attribute: attribute}} -> attribute == "children"
    end

    selectors_without_children =
      selectors
      |> Enum.reject(filter_with_children)
      |> Enum.map(fn {key, _value} -> String.to_integer(key) end)

    selectors_with_children =
      selectors
      |> Enum.filter(filter_with_children)
      |> Enum.map(fn {key, _value} -> String.to_integer(key) end)

    selectors_with_children ++
      Enum.reject(assigns[:selectors_with_children] || [], fn selector_index ->
        selector_index in selectors_without_children
      end)
  end
end
