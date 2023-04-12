defmodule Crawlex.ScrapersTest do
  use Crawlex.DataCase

  alias Crawlex.Scrapers

  describe "scrapers" do
    alias Crawlex.Scrapers.Scraper

    import Crawlex.ScrapersFixtures

    @invalid_attrs %{
      base_url: nil,
      brand: nil,
      category: nil,
      color: nil,
      description: nil,
      images: nil,
      name: nil,
      price: nil,
      sizes: nil,
      sku: nil,
      vendor: nil
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
        base_url: "https://www.some-base-url.com",
        brand: "some brand",
        category: "some category",
        color: "some color",
        description: "some description",
        images: "some images",
        name: "some name",
        price: "some price",
        sizes: "some sizes",
        sku: "some sku",
        vendor: "some vendor"
      }

      assert {:ok, %Scraper{} = scraper} = Scrapers.create_scraper(valid_attrs)
      assert scraper.base_url == "https://www.some-base-url.com"
      assert scraper.brand == "some brand"
      assert scraper.category == "some category"
      assert scraper.color == "some color"
      assert scraper.description == "some description"
      assert scraper.images == "some images"
      assert scraper.name == "some name"
      assert scraper.price == "some price"
      assert scraper.sizes == "some sizes"
      assert scraper.sku == "some sku"
      assert scraper.vendor == "some vendor"
    end

    test "create_scraper/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scrapers.create_scraper(@invalid_attrs)
    end

    test "update_scraper/2 with valid data updates the scraper" do
      scraper = scraper_fixture()

      update_attrs = %{
        base_url: "https://www.some-updated-base-url.com",
        brand: "some updated brand",
        category: "some updated category",
        color: "some updated color",
        description: "some updated description",
        images: "some updated images",
        name: "some updated name",
        price: "some updated price",
        sizes: "some updated sizes",
        sku: "some updated sku",
        vendor: "some updated vendor"
      }

      assert {:ok, %Scraper{} = scraper} = Scrapers.update_scraper(scraper, update_attrs)
      assert scraper.base_url == "https://www.some-updated-base-url.com"
      assert scraper.brand == "some updated brand"
      assert scraper.category == "some updated category"
      assert scraper.color == "some updated color"
      assert scraper.description == "some updated description"
      assert scraper.images == "some updated images"
      assert scraper.name == "some updated name"
      assert scraper.price == "some updated price"
      assert scraper.sizes == "some updated sizes"
      assert scraper.sku == "some updated sku"
      assert scraper.vendor == "some updated vendor"
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
