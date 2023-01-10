defmodule ConduitWeb.Schema do
  use Absinthe.Schema
  import_types(ConduitWeb.Schema.ContentTypes)

  alias ConduitWeb.Resolvers

  query do
    @desc "Get all articles"
    field :articles, list_of(:article) do
      resolve(&Resolvers.Content.list_articles/3)
    end

    @desc "Get an article"
    field :article, :article do
      arg(:slug, non_null(:string))
      resolve(&Resolvers.Content.get_article/3)
    end

    field :profile, :profile do
      arg(:username, non_null(:string))
      resolve(&Resolvers.Content.get_profile/3)
    end

    field :user, non_null(:user) do
      resolve(&Resolvers.Content.get_current_user/3)
    end
  end
end
