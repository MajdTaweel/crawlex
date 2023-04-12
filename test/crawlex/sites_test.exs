defmodule Crawlex.SitesTest do
  use Crawlex.DataCase

  alias Crawlex.Sites

  describe "sites" do
    alias Crawlex.Sites.Site

    import Crawlex.SitesFixtures

    @invalid_attrs %{base_url: nil, name: nil}

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Sites.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Sites.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      valid_attrs = %{base_url: "some base_url", name: "some name"}

      assert {:ok, %Site{} = site} = Sites.create_site(valid_attrs)
      assert site.base_url == "some base_url"
      assert site.name == "some name"
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sites.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()
      update_attrs = %{base_url: "some updated base_url", name: "some updated name"}

      assert {:ok, %Site{} = site} = Sites.update_site(site, update_attrs)
      assert site.base_url == "some updated base_url"
      assert site.name == "some updated name"
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
