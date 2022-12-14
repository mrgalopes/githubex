defmodule GithubexWeb.ErrorView do
  use GithubexWeb, :view

  alias Ecto.Changeset

  def render("error.json", %{result: %Changeset{} = changeset}) do
    %{
      message: traverse_changeset(changeset)
    }
  end

  def render("error.json", %{result: result}) do
    %{
      result: result
    }
  end

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  defp traverse_changeset(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
