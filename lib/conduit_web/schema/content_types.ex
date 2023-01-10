defmodule ConduitWeb.Schema.ContentTypes do
  alias ConduitWeb.Resolvers
  use Absinthe.Schema.Notation

  object :article do
    field :slug, non_null(:string)
    field :title, non_null(:string)
    field :description, :string
    field :body, :string
    field :created_at, non_null(:string)

    field :author, non_null(:profile) do
      resolve(&Resolvers.Content.get_profile/3)
    end
  end

  object :profile do
    field :username, non_null(:string)
    field :bio, :string
    field :image, :string

    field :articles, non_null(list_of(:article)) do
      resolve(&Resolvers.Content.list_articles/3)
    end
  end

  object :user do
    field :email, non_null(:string)
  end
end
