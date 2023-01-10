defmodule ConduitWeb.Schema.ContentTypes do
  alias ConduitWeb.Resolvers
  use Absinthe.Schema.Notation

  object :comment do
    field :id, non_null(:id)
    field :created_at, non_null(:string)
    field :updated_at, non_null(:string)
    field :body, :string

    field :author, non_null(:profile) do
      resolve(&Resolvers.Content.get_comment_profile/3)
    end
  end

  object :article do
    field :slug, non_null(:string)
    field :title, non_null(:string)
    field :description, :string
    field :body, :string
    field :created_at, non_null(:string)

    field :favorites_count, non_null(:integer) do
      resolve(&Resolvers.Content.favorites_count/3)
    end

    field :favorited, :boolean do
      resolve(&Resolvers.Content.favorited?/3)
    end

    field :author, non_null(:profile) do
      resolve(&Resolvers.Content.get_article_profile/3)
    end

    field :comments, non_null(list_of(:comment)) do
      resolve(&Resolvers.Content.get_article_comment/3)
    end
  end

  object :profile do
    field :username, non_null(:string)
    field :bio, :string
    field :image, :string

    field :articles_count, non_null(:integer) do
      resolve(&Resolvers.Content.profile_articles_count/3)
    end

    field :articles, non_null(list_of(:article)) do
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.Content.list_user_articles/3)
    end
  end

  object :user do
    field :email, non_null(:string)

    field :token, non_null(:string) do
      resolve(&Resolvers.Content.get_user_token/3)
    end

    field :profile, non_null(:profile) do
      resolve(&Resolvers.Content.get_user_profile/3)
    end
  end
end
