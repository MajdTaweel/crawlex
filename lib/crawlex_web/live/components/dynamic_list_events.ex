defmodule CrawlexWeb.Components.DynamicListEvents do
  @moduledoc """
  Macro for defining default functions for (flat/nested) dynamic list forms.
  """

  defmacro __using__(_opts) do
    quote do
      use CrawlexWeb, :live_component
      @before_compile CrawlexWeb.Components.DynamicListEvents
    end
  end

  defmacro __before_compile__(_opts) do
    quote do
      alias Ecto.Changeset

      def handle_event("add-new", _params, socket) do
        key = socket.assigns.key
        changeset = socket.assigns.form.source
        list = Changeset.get_field(changeset, key)

        form =
          changeset
          |> Changeset.put_change(key, list ++ [%{}])
          |> to_form()

        {:noreply, assign(socket, :form, form)}
      end

      def handle_event("remove", %{"index" => index}, socket) do
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
  end
end
