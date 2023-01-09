defmodule ConduitWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  object :article do
    field :slug, non_null(:string)
    field :title, non_null(:string)
    field :description, :string
    field :body, :string
    field :created_at, non_null(:string)
  end
end
