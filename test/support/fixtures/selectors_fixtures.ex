defmodule Crawlex.SelectorsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crawlex.Selectors` context.
  """

  alias Crawlex.SitesFixtures

  @doc """
  Generate a selector.
  """
  def selector_fixture(attrs \\ %{}) do
    %{id: site_id} = SitesFixtures.site_fixture()

    {:ok, selector} =
      attrs
      |> Enum.into(%{
        brand: "some brand",
        category: "some category",
        colors: %{},
        description: "some description",
        images: "some images",
        name: "some name",
        price: "some price",
        site_id: site_id,
        sizes: %{},
        sku: "some sku",
        type: "some type",
        wait_for_js: ["option1", "option2"],
        wait_for_selectors: ["option1", "option2"]
      })
      |> Crawlex.Selectors.create_selector()

    selector
  end
end
