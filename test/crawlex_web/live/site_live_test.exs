defmodule CrawlexWeb.SiteLiveTest do
  use CrawlexWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Crawlex.Sites
  alias Crawlex.Sites.Site
  alias Crawlex.SitesFixtures

  describe "site edit page" do
    test "filled site edit form", %{conn: conn} do
      %Site{id: id, name: name} = SitesFixtures.site_fixture()
      {:ok, view, _html} = live(conn, "/sites/#{id}")

      assert view
             |> element("input[name='site[name]']")
             |> render() =~ name
    end

    test "test edit site", %{conn: conn} do
      %Site{id: id} = SitesFixtures.site_fixture()
      {:ok, view, _html} = live(conn, "/sites/#{id}")

      view
      |> form("form", site: %{name: "some updated name"})
      |> render_submit()

      flash =
        assert_redirect(
          view,
          "/sites/#{id}"
        )

      assert flash["info"] == "Site saved successfully."

      assert %Site{id: ^id, name: "some updated name"} = Sites.get_site!(id)
    end
  end
end
