defmodule Crawlex.SitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crawlex.Sites` context.
  """

  @doc """
  Generate a unique site base_url.
  """
  def unique_site_base_url, do: "https://some-base_url#{System.unique_integer([:positive])}"

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        base_url: unique_site_base_url(),
        browser_rendering: true,
        cookies: %{},
        country_code: "some country_code",
        name: "some name",
        query_parameters: %{},
        selectors: %{},
        wait_for_js: ["option1", "option2"],
        wait_for_selectors: ["option1", "option2"]
      })
      |> Crawlex.Sites.create_site()

    site
  end
end
