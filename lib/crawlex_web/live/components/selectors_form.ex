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

      <.inputs_for :let={group} field={@form[:selectors]}>
        <div class="grid grid-cols-2 gap-x-2 gap-y-4 py-4">
          Selectors Form Group
        </div>
      </.inputs_for>
    </div>
    """
  end
end
