defmodule Githubex.Users.CreateTest do
  use Githubex.DataCase, async: true

  alias Githubex.{Error, User}
  alias Githubex.Users.Create

  describe "call/1" do
    test "should create user when given required params" do
      params = %{password: "123456"}

      {:ok, %User{id: id}} = Create.call(params)

      assert %User{id: ^id} = Repo.get(User, id)
    end

    test "should return error when cannot create user" do
      assert {:error,
              %Error{
                status: :bad_request,
                result: %Ecto.Changeset{
                  valid?: false
                }
              }} = Create.call(%{})
    end
  end
end
