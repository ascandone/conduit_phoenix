defmodule Conduit.Guardian do
  use Guardian, otp_app: :conduit
  alias Conduit.Accounts
  alias Conduit.Accounts.User

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, to_string(id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In above `subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.

    user = Accounts.get_user_by_id(id)
    {:ok, user}
  end

  def resource_from_claims(_claims) do
    {:error, :not_implemented}
  end
end
