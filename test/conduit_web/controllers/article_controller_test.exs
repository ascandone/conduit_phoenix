defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase, async: true
  import Conduit.AccountsFixtures

  describe "POST /articles" do
    setup [:login]

    test "should create an article", %{conn: conn} do
      article_args = %{
        title: "How to train your dragon",
        description: "Ever wonder how?",
        body: "You have to believe"
      }

      conn = post(conn, ~p"/api/articles", %{article: article_args})

      assert %{"article" => article} = json_response(conn, 200)

      assert article["slug"] == "how-to-train-your-dragon"
      assert article["title"] == "How to train your dragon"
      assert article["description"] == "Ever wonder how?"
      assert article["body"] == "You have to believe"
    end
  end
end
