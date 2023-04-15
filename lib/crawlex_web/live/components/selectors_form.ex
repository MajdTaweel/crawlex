defmodule CrawlexWeb.Components.SelectorsForm do
  @moduledoc """
  Site selectors form group.
  """

  use CrawlexWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1 class="font-bold">Scraper Selectors</h1>

      <.inputs_for :let={group} field={@form[:selector]}>
        <div class="grid grid-cols-2 gap-x-2 gap-y-4 py-4">
          <.input field={group[:name]} type="text" label="Name" />
          <.input field={group[:sku]} type="text" label="SKU" />
        </div>
      </.inputs_for>
    </div>
    """
  end
end
