defmodule Crawlex.SitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Crawlex.Sites` context.
  """

  @doc """
  Generate a unique site base_url.
  """
  def unique_site_base_url, do: "some base_url#{System.unique_integer([:positive])}"

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        base_url: unique_site_base_url()
      })
      |> Crawlex.Sites.create_site()

    site
  end
end
