defmodule ConduitWeb.GraphqlTest do
  use ConduitWeb.ConnCase
  import Conduit.AccountsFixtures
  import Conduit.BlogFixtures

  test "profile object", %{conn: conn} do
    user = user_fixture(%{bio: "example bio", image: "/example/image"})

    conn =
      post(conn, "/graphql", %{
        "query" => """
          {
            profile(username: "#{user.username}") {
              username
              image
              bio
            }
          }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "profile" => %{
                 "username" => user.username,
                 "image" => user.image,
                 "bio" => user.bio
               }
             }
           }
  end

  test "profile articles", %{conn: conn} do
    user = user_fixture()
    a1 = article_fixture(%{author_id: user.id})
    a2 = article_fixture(%{author_id: user.id})

    conn =
      post(conn, "/graphql", %{
        "query" => """
          {
            profile(username: "#{user.username}") {
              articles {
                slug
              }
            }
          }
        """
      })

    assert json_response(conn, 200) == %{
             "data" => %{
               "profile" => %{
                 "articles" => [
                   %{"slug" => a1.slug},
                   %{"slug" => a2.slug}
                 ]
               }
             }
           }
  end
end
