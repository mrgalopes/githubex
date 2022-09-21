defmodule Githubex.Github.Client do
  use Tesla

  alias Githubex.Error
  alias Githubex.Github.Response
  alias Tesla.Env

  @base_url "https://api.github.com/users/"

  plug Tesla.Middleware.Headers, [{"user-agent", "mrgalopes"}]
  plug Tesla.Middleware.JSON

  def get_repos(url \\ @base_url, username) do
    "#{url}#{username}/repos"
    |> get()
    |> handle_get_repos()
  end

  defp handle_get_repos({:ok, %Env{status: 404}}) do
    {:error, Error.build(:not_found, "User not found")}
  end

  defp handle_get_repos({:ok, %Env{status: 200, body: body}}) do
    repos =
      body
      |> Enum.map(&Response.build/1)
      |> Enum.filter(fn repo -> not has_error(repo) end)
      |> Enum.map(fn {:ok, repo} -> repo end)

    {:ok, repos}
  end

  defp handle_get_repos(_result) do
    {:error, Error.build(:internal_server_error, "Could not fetch repos")}
  end

  defp has_error({:ok, _repo}), do: false
  defp has_error({:error, _error}), do: true
end
