defmodule Crawlex.SelectorsTest do
  use Crawlex.DataCase

  alias Crawlex.Selectors
  alias Crawlex.SitesFixtures

  describe "selectors" do
    alias Crawlex.Selectors.Selector

    import Crawlex.SelectorsFixtures

    @invalid_attrs %{
      brand: nil,
      category: nil,
      colors: nil,
      description: nil,
      images: nil,
      name: nil,
      price: nil,
      site_id: nil,
      sizes: nil,
      sku: nil,
      type: nil,
      wait_for_js: nil,
      wait_for_selectors: nil
    }

    test "list_selectors/0 returns all selectors" do
      selector = selector_fixture()
      assert Selectors.list_selectors() == [selector]
    end

    test "get_selector!/1 returns the selector with given id" do
      selector = selector_fixture()
      assert Selectors.get_selector!(selector.id) == selector
    end

    test "create_selector/1 with valid data creates a selector" do
      %{id: site_id} = SitesFixtures.site_fixture()

      valid_attrs = %{
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
        wait_for_js: %{},
        wait_for_selectors: %{}
      }

      assert {:ok, %Selector{} = selector} = Selectors.create_selector(valid_attrs)
      assert selector.brand == "some brand"
      assert selector.category == "some category"
      assert selector.colors == []
      assert selector.description == "some description"
      assert selector.images == "some images"
      assert selector.name == "some name"
      assert selector.price == "some price"
      assert selector.site_id == site_id
      assert selector.sizes == []
      assert selector.sku == "some sku"
      assert selector.type == "some type"
      assert selector.wait_for_js == []
      assert selector.wait_for_selectors == []
    end

    test "create_selector/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Selectors.create_selector(@invalid_attrs)
    end

    test "update_selector/2 with valid data updates the selector" do
      selector = selector_fixture()

      update_attrs = %{
        brand: "some updated brand",
        category: "some updated category",
        colors: %{},
        description: "some updated description",
        images: "some updated images",
        name: "some updated name",
        price: "some updated price",
        sizes: %{},
        sku: "some updated sku",
        type: "some updated type",
        wait_for_js: %{},
        wait_for_selectors: %{}
      }

      assert {:ok, %Selector{} = selector} = Selectors.update_selector(selector, update_attrs)
      assert selector.brand == "some updated brand"
      assert selector.category == "some updated category"
      assert selector.colors == []
      assert selector.description == "some updated description"
      assert selector.images == "some updated images"
      assert selector.name == "some updated name"
      assert selector.price == "some updated price"
      assert selector.sizes == []
      assert selector.sku == "some updated sku"
      assert selector.type == "some updated type"
      assert selector.wait_for_js == []
      assert selector.wait_for_selectors == []
    end

    test "update_selector/2 with invalid data returns error changeset" do
      selector = selector_fixture()
      assert {:error, %Ecto.Changeset{}} = Selectors.update_selector(selector, @invalid_attrs)
      assert selector == Selectors.get_selector!(selector.id)
    end

    test "delete_selector/1 deletes the selector" do
      selector = selector_fixture()
      assert {:ok, %Selector{}} = Selectors.delete_selector(selector)
      assert_raise Ecto.NoResultsError, fn -> Selectors.get_selector!(selector.id) end
    end

    test "change_selector/1 returns a selector changeset" do
      selector = selector_fixture()
      assert %Ecto.Changeset{} = Selectors.change_selector(selector)
    end
  end
end
