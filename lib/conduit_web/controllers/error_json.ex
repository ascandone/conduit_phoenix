defmodule ConduitWeb.ErrorJSON do
  def render_credential_errors do
    render_errors(%{"email or password" => ["is invalid"]})
  end

  def render_not_found(resource) do
    render_errors(%{resource => ["not found"]})
  end

  def render_changeset(%Ecto.Changeset{} = changeset) do
    errors =
      changeset.errors
      |> Enum.map(fn {field, {error, _}} ->
        {field, [error]}
      end)
      |> Enum.into(%{})

    render_errors(errors)
  end

  defp render_errors(errors) do
    %{"errors" => errors}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
