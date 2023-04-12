defmodule Crawlex.ScrapersTest do
  use Crawlex.DataCase

  alias Crawlex.Scrapers

  describe "scrapers" do
    alias Crawlex.Scrapers.Scraper

    import Crawlex.ScrapersFixtures

    @invalid_attrs %{
      brand: nil,
      category: nil,
      colors: nil,
      description: nil,
      images: nil,
      name: nil,
      price: nil,
      sizes: nil,
      sku: nil,
      type: nil,
      wait_for_js: nil,
      wait_for_selectors: nil
    }

    test "list_scrapers/0 returns all scrapers" do
      scraper = scraper_fixture()
      assert Scrapers.list_scrapers() == [scraper]
    end

    test "get_scraper!/1 returns the scraper with given id" do
      scraper = scraper_fixture()
      assert Scrapers.get_scraper!(scraper.id) == scraper
    end

    test "create_scraper/1 with valid data creates a scraper" do
      valid_attrs = %{
        brand: "some brand",
        category: "some category",
        colors: %{},
        description: "some description",
        images: "some images",
        name: "some name",
        price: "some price",
        sizes: %{},
        sku: "some sku",
        type: "some type",
        wait_for_js: %{},
        wait_for_selectors: %{}
      }

      assert {:ok, %Scraper{} = scraper} = Scrapers.create_scraper(valid_attrs)
      assert scraper.brand == "some brand"
      assert scraper.category == "some category"
      assert scraper.colors == []
      assert scraper.description == "some description"
      assert scraper.images == "some images"
      assert scraper.name == "some name"
      assert scraper.price == "some price"
      assert scraper.sizes == []
      assert scraper.sku == "some sku"
      assert scraper.type == "some type"
      assert scraper.wait_for_js == []
      assert scraper.wait_for_selectors == []
    end

    test "create_scraper/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scrapers.create_scraper(@invalid_attrs)
    end

    test "update_scraper/2 with valid data updates the scraper" do
      scraper = scraper_fixture()

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

      assert {:ok, %Scraper{} = scraper} = Scrapers.update_scraper(scraper, update_attrs)
      assert scraper.brand == "some updated brand"
      assert scraper.category == "some updated category"
      assert scraper.colors == []
      assert scraper.description == "some updated description"
      assert scraper.images == "some updated images"
      assert scraper.name == "some updated name"
      assert scraper.price == "some updated price"
      assert scraper.sizes == []
      assert scraper.sku == "some updated sku"
      assert scraper.type == "some updated type"
      assert scraper.wait_for_js == []
      assert scraper.wait_for_selectors == []
    end

    test "update_scraper/2 with invalid data returns error changeset" do
      scraper = scraper_fixture()
      assert {:error, %Ecto.Changeset{}} = Scrapers.update_scraper(scraper, @invalid_attrs)
      assert scraper == Scrapers.get_scraper!(scraper.id)
    end

    test "delete_scraper/1 deletes the scraper" do
      scraper = scraper_fixture()
      assert {:ok, %Scraper{}} = Scrapers.delete_scraper(scraper)
      assert_raise Ecto.NoResultsError, fn -> Scrapers.get_scraper!(scraper.id) end
    end

    test "change_scraper/1 returns a scraper changeset" do
      scraper = scraper_fixture()
      assert %Ecto.Changeset{} = Scrapers.change_scraper(scraper)
    end
  end
end
