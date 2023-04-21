defmodule CrawlexWeb.Components.DynamicListForm do
  @moduledoc """
  Generates a dynamic list/array form group.
  """

  use CrawlexWeb.Components.DynamicListEvents

  def render(assigns) do
    ~H"""
    <div>
      <div class="flex justify-between">
        <h1 class="font-bold"><%= title_from_atom(@key) %></h1>
        <.button type="button" title="Add New" phx-click="add-new" phx-target={@myself}>
          <.icon name="hero-plus" />
        </.button>
      </div>

      <div class="flex flex-col gap-y-4 py-4">
        <.inputs_for :let={group} field={@form[@key]}>
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
          </div>
        </.inputs_for>
      </div>
    </div>
    """
  end
end
