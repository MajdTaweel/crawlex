defmodule CrawlexWeb.Live.Helpers do
  @moduledoc """
  Custom helpers for live views and components.
  """

  def title_from_atom(atom) when is_atom(atom) do
    atom
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map_join(" ", &String.capitalize/1)
  end
end
