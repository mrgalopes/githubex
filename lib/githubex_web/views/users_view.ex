defmodule GithubexWeb.UsersView do
  def render("create.json", %{user: user}) do
    %{
      id: user.id
    }
  end
end
