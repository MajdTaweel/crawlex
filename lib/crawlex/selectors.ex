defmodule Crawlex.Selectors do
  @moduledoc """
  The Selectors context.
  """

  import Ecto.Query, warn: false
  alias Crawlex.Repo

  alias Crawlex.Selectors.Selector

  @doc """
  Returns the list of selectors.

  ## Examples

      iex> list_selectors()
      [%Selector{}, ...]

  """
  def list_selectors do
    Repo.all(Selector)
  end

  @doc """
  Gets a single selector.

  Raises `Ecto.NoResultsError` if the Selector does not exist.

  ## Examples

      iex> get_selector!(123)
      %Selector{}

      iex> get_selector!(456)
      ** (Ecto.NoResultsError)

  """
  def get_selector!(id), do: Repo.get!(Selector, id)

  @doc """
  Gets a single selector using a url.

  Raises `Ecto.NoResultsError` if the Selector does not exist.

  ## Examples

      iex> get_selector_by_url!(https://example.com/example-slug)
      %Selector{}

      iex> get_selector_by_url!(https://example.com/wrong-slug)
      ** (Ecto.NoResultsError)

  """
  def get_selector_by_url!(url) do
    base_url = base_url_from_url!(url)

    Repo.one!(
      from s in Selector,
        join: si in assoc(s, :site),
        where: si.base_url == ^base_url,
        select: s
    )
  end

  @doc """
  Creates a selector.

  ## Examples

      iex> create_selector(%{field: value})
      {:ok, %Selector{}}

      iex> create_Selector(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_selector(attrs \\ %{}) do
    %Selector{}
    |> Selector.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a selector.

  ## Examples

      iex> update_selector(selector, %{field: new_value})
      {:ok, %Selector{}}

      iex> update_selector(selector, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_selector(%Selector{} = selector, attrs) do
    selector
    |> Selector.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a selector.

  ## Examples

      iex> delete_selector(selector)
      {:ok, %Selector{}}

      iex> delete_selector(selector)
      {:error, %Ecto.Changeset{}}

  """
  def delete_selector(%Selector{} = selector) do
    Repo.delete(selector)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking selector changes.

  ## Examples

      iex> change_selector(selector)
      %Ecto.Changeset{data: %Selector{}}

  """
  def change_selector(%Selector{} = selector, attrs \\ %{}) do
    Selector.changeset(selector, attrs)
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
