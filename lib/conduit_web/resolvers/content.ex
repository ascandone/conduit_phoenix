defmodule ConduitWeb.Resolvers.Content do
  alias Conduit.Blog.Comment
  alias Conduit.{Accounts, Blog}
  alias Conduit.Accounts.User
  alias Conduit.Blog.Article

  def list_articles(_parent, args, _resolution) do
    articles = Blog.list_articles(args)
    {:ok, articles}
  end

  def articles_count(_parent, _args, _resolution) do
    count = Blog.count_articles()
    {:ok, count}
  end

  def profile_articles_count(%User{username: username}, _args, _resolution) do
    count = Blog.count_articles(author: username)
    {:ok, count}
  end

  def list_user_articles(%User{username: username}, args, _resolution) do
    args = Map.put(args, :author, username)
    articles = Blog.list_articles(args)
    {:ok, articles}
  end

  def get_article(_parent, %{slug: slug}, _resolution) do
    article = Blog.get_article_by_slug(slug)
    {:ok, article}
  end

  def get_profile(_parent, %{username: username}, _resolution) do
    user = Accounts.get_user_by_username(username)
    {:ok, user}
  end

  def get_comment_profile(%Comment{author_id: id}, _args, _resolution) do
    user = Accounts.get_user_by_id(id)
    {:ok, user}
  end

  def get_article_profile(%Article{author_id: id}, _args, _resolution) do
    user = Accounts.get_user_by_id(id)
    {:ok, user}
  end

  def get_current_user(_parent, _args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def get_user_profile(%User{} = user, _args, _resolution) do
    {:ok, user}
  end

  def get_comment_by_id(_parent, %{id: id}, _resolution) do
    comment = Blog.get_comment_by_id(id)
    {:ok, comment}
  end

  def get_article_comment(%Article{} = article, _args, _resolution) do
    comments = Blog.get_article_comments(article)
    {:ok, comments}
  end
end
