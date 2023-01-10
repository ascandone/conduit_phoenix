defmodule ConduitWeb.CommentJSON do
  alias ConduitWeb.ProfileJSON
  alias Conduit.Blog.Comment

  defp comment(%{comment: %Comment{} = comment}) do
    %{
      "id" => comment.id,
      "createdAt" => DateTime.to_iso8601(comment.created_at),
      "updatedAt" => DateTime.to_iso8601(comment.updated_at),
      "body" => comment.body,
      "author" => ProfileJSON.profile(%{profile: comment.author})
    }
  end

  def show(%{comment: %Comment{} = comment}) do
    %{"comment" => comment(%{comment: comment})}
  end

  def index(%{comments: comments}) do
    %{
      "comments" =>
        Enum.map(comments, fn comment ->
          comment(%{comment: comment})
        end)
    }
  end
end
