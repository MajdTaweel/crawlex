defmodule CrawlexWeb.Live.Helpers do
  @moduledoc """
  Custom helpers for live views and components.
  """

  import Phoenix.Component

  alias Ecto.Changeset

  def title_from_atom(atom) when is_atom(atom) do
    atom
    |> Atom.to_string()
    |> String.replace("_", " ")
    |> String.split(" ")
    |> Enum.map_join(" ", &String.capitalize/1)
  end

  def handle_dynamic_list_form_event("add-new", _params, socket) do
    key = socket.assigns.key
    changeset = socket.assigns.form.source
    list = Changeset.get_field(changeset, key)

    form =
      changeset
      |> Changeset.put_change(key, list ++ [%{}])
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end

  def handle_dynamic_list_form_event("remove", %{"index" => index}, socket) do
    key = socket.assigns.key
    index = String.to_integer(index)
    changeset = socket.assigns.form.source

    list =
      changeset
      |> Changeset.get_field(key)
      |> List.delete_at(index)

    form =
      changeset
      |> Changeset.put_change(key, list)
      |> to_form()

    {:noreply, assign(socket, :form, form)}
  end
end
