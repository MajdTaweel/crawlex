defmodule Crawlex.Sites.Site do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "sites" do
    field :base_url, :string

    embeds_many :cookies, Cookie, primary_key: false, on_replace: :delete do
      field :domain, :string
      field :name, :string
      field :value, :string
    end

    field :country_code, :string
    field :name, :string

    embeds_many :query_parameters, QueryParameter, primary_key: false, on_replace: :delete do
      field :name, :string
      field :value, :string
    end

    has_one :selector, Crawlex.Selectors.Selector

    timestamps()
  end

  @fields [
    :name,
    :base_url,
    :country_code
  ]
  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, @fields)
    |> cast_embed(:cookies, with: &cookie_changeset/2)
    |> cast_embed(:query_parameters, with: &query_parameter_changeset/2)
    |> validate_required(@fields)
    |> validate_and_trim_base_url()
    |> unique_constraint(:base_url)
  end

  defp cookie_changeset(cookie, attrs) do
    cookie
    |> cast(attrs, [:name, :value, :domain])
    |> validate_required([:name, :value])
  end

  defp query_parameter_changeset(query_parameter, attrs) do
    query_parameter
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end

  defp validate_and_trim_base_url(site) do
    base_url = get_field(site, :base_url)
    maybe_validate_and_trim_base_url(site, base_url)
  end

  defp maybe_validate_and_trim_base_url(site, nil), do: site

  defp maybe_validate_and_trim_base_url(site, base_url) do
    case URI.new(base_url) do
      {:ok, %{host: host, scheme: scheme}} when not is_nil(host) and not is_nil(scheme) ->
        base_url = "#{scheme}://#{String.trim(host, "/")}"

        put_change(site, :base_url, base_url)

      {:error, part} ->
        add_error(site, :base_url, part)

      _ ->
        add_error(site, :base_url, "Invalid URL")
    end
  end
end
