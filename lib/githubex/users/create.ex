defmodule Githubex.Users.Create do
  alias Githubex.{Error, Repo, User}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:error, error}) do
    {:error, Error.build(:bad_request, error)}
  end

  defp handle_insert({:ok, _user} = result), do: result
end
