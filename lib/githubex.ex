defmodule Githubex do
  @moduledoc """
  Githubex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Githubex.Github.Client, as: GithubClient
  alias Githubex.Users.Create, as: UsersCreate

  defdelegate get_github_repos(username), to: GithubClient, as: :get_repos

  defdelegate create_user(params), to: UsersCreate, as: :call
end
