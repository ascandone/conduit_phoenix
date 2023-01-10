defmodule ConduitWeb.Schema do
  use Absinthe.Schema
  import_types(ConduitWeb.Schema.ContentTypes)

  alias ConduitWeb.Resolvers

  query do
    field :articles_count, non_null(:integer) do
      resolve(&Resolvers.Content.articles_count/3)
    end

    @desc "Get all articles"
    field :articles, list_of(:article) do
      arg(:limit, :integer)
      arg(:offset, :integer)
      resolve(&Resolvers.Content.list_articles/3)
    end

    @desc "Get an article"
    field :article, :article do
      arg(:slug, non_null(:string))
      resolve(&Resolvers.Content.get_article/3)
    end

    field :comment, :comment do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Content.get_comment_by_id/3)
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
