defmodule Githubex.Users.Get do
  alias Githubex.{Error, Repo, User}

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.build(:bad_request, "User not found")}
      user -> {:ok, user}
    end
  end
end
