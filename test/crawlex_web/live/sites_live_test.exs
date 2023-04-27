defmodule CrawlexWeb.SitesLiveTest do
  use CrawlexWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Crawlex.Sites.Site
  alias Crawlex.SitesFixtures

  describe "sites page" do
    test "empty sites table", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/sites")
      assert html =~ "No sites yet..."
    end

    test "sites table with records", %{conn: conn} do
      %Site{id: id1} = SitesFixtures.site_fixture()
      %Site{id: id2} = SitesFixtures.site_fixture()

      {:ok, view, _html} = live(conn, "/sites")

      assert view
             |> element("#site-#{id1}")
             |> has_element?()

      assert view
             |> element("#site-#{id2}")
             |> has_element?()
    end
  end
end
