defmodule Crawlex.Scrapers do
  @moduledoc """
  The Scrapers context.
  """

  import Ecto.Query, warn: false
  alias Crawlex.Repo

  alias Crawlex.Scrapers.Scraper

  @doc """
  Returns the list of scrapers.

  ## Examples

      iex> list_scrapers()
      [%Scraper{}, ...]

  """
  def list_scrapers do
    Repo.all(Scraper)
  end

  @doc """
  Gets a single scraper.

  Raises `Ecto.NoResultsError` if the Scraper does not exist.

  ## Examples

      iex> get_scraper!(123)
      %Scraper{}

      iex> get_scraper!(456)
      ** (Ecto.NoResultsError)

  """
  def get_scraper!(id), do: Repo.get!(Scraper, id)

  @doc """
  Gets a single scraper using a url.

  Raises `Ecto.NoResultsError` if the Scraper does not exist.

  ## Examples

      iex> get_scraper_by_url!(https://example.com/example-slug)
      %Scraper{}

      iex> get_scraper_by_url!(https://example.com/wrong-slug)
      ** (Ecto.NoResultsError)

  """
  def get_scraper_by_url!(url) do
    base_url = base_url_from_url!(url)

    Repo.one!(
      from s in Scraper,
        join: si in assoc(s, :site),
        where: si.base_url == ^base_url,
        select: s
    )
  end

  @doc """
  Creates a scraper.

  ## Examples

      iex> create_scraper(%{field: value})
      {:ok, %Scraper{}}

      iex> create_scraper(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_scraper(attrs \\ %{}) do
    %Scraper{}
    |> Scraper.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a scraper.

  ## Examples

      iex> update_scraper(scraper, %{field: new_value})
      {:ok, %Scraper{}}

      iex> update_scraper(scraper, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_scraper(%Scraper{} = scraper, attrs) do
    scraper
    |> Scraper.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a scraper.

  ## Examples

      iex> delete_scraper(scraper)
      {:ok, %Scraper{}}

      iex> delete_scraper(scraper)
      {:error, %Ecto.Changeset{}}

  """
  def delete_scraper(%Scraper{} = scraper) do
    Repo.delete(scraper)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking scraper changes.

  ## Examples

      iex> change_scraper(scraper)
      %Ecto.Changeset{data: %Scraper{}}

  """
  def change_scraper(%Scraper{} = scraper, attrs \\ %{}) do
    Scraper.changeset(scraper, attrs)
  end

  defp base_url_from_url!(url) do
    case URI.new!(url) do
      %{host: host, scheme: scheme} when not is_nil(host) and not is_nil(scheme) ->
        "#{scheme}://#{String.trim(host, "/")}"

      _ ->
        raise "Invalid URL"
    end
  end
end
