defmodule ConduitWeb.Schema.ContentTypes do
  alias ConduitWeb.Resolvers
  use Absinthe.Schema.Notation

  object :comment do
    field :id, non_null(:id)
    field :created_at, non_null(:string)
    field :updated_at, non_null(:string)
    field :body, :string
  end

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

    field :profile, non_null(:profile) do
      resolve(&Resolvers.Content.get_user_profile/3)
    end
  end
end
