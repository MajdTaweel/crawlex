defmodule Crawlex.SitesTest do
  use Crawlex.DataCase

  alias Crawlex.Sites

  describe "sites" do
    alias Crawlex.Sites.Site

    import Crawlex.SitesFixtures

    @invalid_attrs %{
      base_url: nil,
      browser_rendering: nil,
      cookies: nil,
      country_code: nil,
      name: nil,
      query_parameters: nil,
      selectors: nil,
      wait_for_js: nil,
      wait_for_selectors: nil
    }

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Sites.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Sites.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      valid_attrs = %{
        base_url: "https://some-base_url",
        browser_rendering: true,
        cookies: %{},
        country_code: "some country_code",
        name: "some name",
        query_parameters: %{},
        selectors: %{},
        wait_for_js: ["option1", "option2"],
        wait_for_selectors: ["option1", "option2"]
      }

      assert {:ok, %Site{} = site} = Sites.create_site(valid_attrs)
      assert site.base_url == "https://some-base_url"
      assert site.browser_rendering == true
      assert site.cookies == []
      assert site.country_code == "some country_code"
      assert site.name == "some name"
      assert site.query_parameters == []
      assert site.selectors == []
      assert site.wait_for_js == ["option1", "option2"]
      assert site.wait_for_selectors == ["option1", "option2"]
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sites.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()

      update_attrs = %{
        base_url: "https://some-updated-base_url",
        browser_rendering: false,
        cookies: %{},
        country_code: "some updated country_code",
        name: "some updated name",
        query_parameters: %{},
        selectors: %{},
        wait_for_js: ["option1"],
        wait_for_selectors: ["option1"]
      }

      assert {:ok, %Site{} = site} = Sites.update_site(site, update_attrs)
      assert site.base_url == "https://some-updated-base_url"
      assert site.browser_rendering == false
      assert site.cookies == []
      assert site.country_code == "some updated country_code"
      assert site.name == "some updated name"
      assert site.query_parameters == []
      assert site.selectors == []
      assert site.wait_for_js == ["option1"]
      assert site.wait_for_selectors == ["option1"]
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Sites.update_site(site, @invalid_attrs)
      assert site == Sites.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Sites.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Sites.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Sites.change_site(site)
    end
  end
end
