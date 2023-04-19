defmodule CrawlexWeb.Components.DynamicListForm do
  @moduledoc """
  Generates a dynamic list/array form group.
  """

  use CrawlexWeb, :live_component

  alias Ecto.Changeset

  attr :polymorphic, :boolean, default: false

  def render(assigns) do
    ~H"""
    <div>
      <%= if @polymorphic do %>
        <%= polymorphic(assigns) %>
      <% else %>
        <%= simple(assigns) %>
      <% end %>
    </div>
    """
  end

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

  defp simple(assigns) do
    ~H"""
    <div class="flex justify-between">
      <h1 class="font-bold"><%= title_from_atom(@key) %></h1>
      <.button type="button" title="Add New" phx-click="add-new" phx-target={@myself}>
        <.icon name="hero-plus" />
      </.button>
    </div>

    <div class="flex flex-col gap-y-4 py-4">
      <.inputs_for :let={group} field={@form[@key]}>
        <div class="flex gap-x-2">
          <%= for field <- @fields do %>
            <.input field={group[field]} label={title_from_atom(field)} />
          <% end %>

          <.button
            type="button"
            class="self-start mt-[34px] bg-red-500 hover:bg-red-400"
            title="Remove"
            phx-click="remove"
            phx-value-index={group.index}
            phx-target={@myself}
          >
            <.icon name="hero-minus-circle" />
          </.button>
        </div>
      </.inputs_for>
    </div>
    """
  end

  defp polymorphic(assigns) do
    ~H"""
    <div class="flex justify-between">
      <h1 class="font-bold"><%= title_from_atom(@key) %></h1>
      <.button type="button" title="Add New" phx-click="add-new" phx-target={@myself}>
        <.icon name="hero-plus" />
      </.button>
    </div>

    <div class="flex flex-col gap-y-4 py-4">
      <%= for group <- polymorphic_embed_inputs_for @form, @key do %>
        <%= case get_polymorphic_type(@form, group, @key) do %>
          <% :simple_selector -> %>
            <div class="flex gap-x-2">
              <%= Phoenix.HTML.Form.hidden_inputs_for(group) %>
              <%= for field <- @fields do %>
                <.input field={group[field]} label={title_from_atom(field)} />
              <% end %>

              <.button
                type="button"
                class="self-start mt-[34px] bg-red-500 hover:bg-red-400"
                title="Remove"
                phx-click="remove"
                phx-value-index={group.index}
                phx-target={@myself}
              >
                <.icon name="hero-minus-circle" />
              </.button>
            </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  defp get_polymorphic_type(%Phoenix.HTML.Form{} = form, field) do
    %schema{} = form.source.data

    case Phoenix.HTML.Form.input_value(form, field) do
      %Ecto.Changeset{data: value} ->
        PolymorphicEmbed.get_polymorphic_type(schema, field, value)

      %_{} = value ->
        PolymorphicEmbed.get_polymorphic_type(schema, field, value)

      _ ->
        nil
    end
  end

  defp get_polymorphic_type(%Phoenix.HTML.Form{} = form, group, field) do
    %schema{} = form.source.data
    PolymorphicEmbed.get_polymorphic_type(schema, field, group.source.data)
  end

  defp polymorphic_embed_inputs_for(form, field)
       when is_atom(field) or is_binary(field) do
    options = Keyword.take(form.options, [:multipart])
    type = get_polymorphic_type(form, field)
    to_polymorphic_form(form.source, form, field, type, options)
  end

  # TODO: remove all this BS
  defp to_polymorphic_form(
         %{action: parent_action} = source_changeset,
         form,
         field,
         type,
         options
       ) do
    # Copied this function from PolymorphicEmbed.HTML.Form.to_form/5, along with the needed private functions,
    # and fixed the id and name generation for polymorphic_embeds_many
    params = Map.get(source_changeset.params || %{}, to_string(field), %{}) |> List.wrap()
    list_data = get_data(source_changeset, field, type) |> List.wrap()

    list_data
    |> Enum.with_index()
    |> Enum.map(fn {data, i} ->
      params = Enum.at(params, i) || %{}

      changeset =
        data
        |> Ecto.Changeset.change()
        |> apply_action(parent_action)

      errors = get_errors(changeset)

      changeset = %Ecto.Changeset{
        changeset
        | action: parent_action,
          params: params,
          errors: errors,
          valid?: errors == []
      }

      id = to_string(form.id <> "_#{field}_#{i}")
      name = to_string(form.name <> "[#{field}][#{i}]")

      %schema{} = form.source.data
      type = PolymorphicEmbed.get_polymorphic_type(schema, field, data)

      %Phoenix.HTML.Form{
        source: changeset,
        impl: Phoenix.HTML.FormData.Ecto.Changeset,
        id: id,
        index: i,
        name: name,
        errors: errors,
        data: data,
        params: params,
        hidden: [__type__: to_string(type)],
        options: options
      }
    end)
  end

  defp get_data(changeset, field, type) do
    struct = Ecto.Changeset.apply_changes(changeset)

    case Map.get(struct, field) do
      nil ->
        module = PolymorphicEmbed.get_polymorphic_module(struct.__struct__, field, type)
        if module, do: struct(module), else: []

      data ->
        data
    end
  end

  # If the parent changeset had no action, we need to remove the action
  # from children changeset so we ignore all errors accordingly.
  defp apply_action(changeset, nil), do: %{changeset | action: nil}
  defp apply_action(changeset, _action), do: changeset

  defp get_errors(%{action: nil}), do: []
  defp get_errors(%{action: :ignore}), do: []
  defp get_errors(%{errors: errors}), do: errors
end
