defmodule Githubex.Users.GetTest do
  use Githubex.DataCase, async: true

  alias Githubex.{Error, User}
  alias Githubex.Users.Get

  describe "by_id/1" do
    test "should return error if user is not found" do
      assert {:error, %Error{}} = Get.by_id(Ecto.UUID.generate())
    end

    test "should return user if user is found" do
      {:ok, %User{id: id}} = Githubex.create_user(%{password: "123456"})

      assert {:ok, %User{id: ^id}} = Get.by_id(id)
    end
  end
end
