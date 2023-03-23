defmodule ExChat.Repo do
  use Ecto.Repo,
    otp_app: :exChat,
    adapter: Ecto.Adapters.Postgres
end
