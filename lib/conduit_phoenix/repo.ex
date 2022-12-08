defmodule Conduit.Repo do
  use Ecto.Repo,
    otp_app: :conduit_phoenix,
    adapter: Ecto.Adapters.Postgres
end
