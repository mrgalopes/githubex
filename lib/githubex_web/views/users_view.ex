defmodule GithubexWeb.UsersView do
  def render("create.json", %{user: user}) do
    %{
      id: user.id
    }
  end

  def render("sign_in.json", %{token: token}), do: %{token: token}
end
