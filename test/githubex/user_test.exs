defmodule Githubex.UserTest do
  use ExUnit.Case, async: true

  alias Ecto.Changeset
  alias Githubex.User

  describe "changeset/1" do
    test "when password is not given, returns invalid changeset" do
      result = User.changeset(%{})

      assert %Changeset{valid?: false} = result
    end

    test "when password is given, it is encrypted" do
      password = "123456"

      result = User.changeset(%{password: password})

      assert %Changeset{
               changes: %{
                 password: ^password,
                 password_hash: password_hash
               },
               valid?: true
             } = result

      assert String.starts_with?(password_hash, "$pbkdf2-sha512")
    end
  end
end
