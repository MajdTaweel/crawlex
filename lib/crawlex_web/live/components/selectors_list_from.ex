defmodule CrawlexWeb.Components.SelectorsListFrom do
  @moduledoc """
  Dynamic nested list form for site selectors.
  """

  use CrawlexWeb.Components.DynamicListEvents, :selectors

  alias Crawlex.Sites
  alias Ecto.Changeset

  @fields ~w(name selector attribute)a
  def render(assigns) do
    assigns = assign(assigns, :fields, @fields)

    ~H"""
    <div>
      <div class="flex justify-between">
        <h1 class="font-bold">Selectors</h1>
        <.button type="button" title="Add New" phx-click="add-new" phx-target={@myself}>
          <.icon name="hero-plus" />
        </.button>
      </div>

      <div class="flex flex-col gap-y-4 py-4">
        <.inputs_for :let={group} field={@form[:selectors]}>
          <div class="flex gap-x-2">
            <%= for field <- @fields do %>
              <.input field={group[field]} label={title_from_atom(field)} />
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

            <.button
              type="button"
              class="self-start mt-[34px]"
              title="Add child"
              phx-click="add-new-child"
              phx-value-index={group.index}
              phx-target={@myself}
            >
              <.icon name="hero-folder-plus" />
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
end
