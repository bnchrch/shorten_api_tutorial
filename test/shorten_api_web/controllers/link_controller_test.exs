defmodule ShortenApiWeb.LinkControllerTest do
  use ShortenApiWeb.ConnCase

  alias ShortenApi.Links
  alias ShortenApi.Links.Link

  @create_attrs %{hash: "some hash", url: "some url"}
  @update_attrs %{hash: "some updated hash", url: "some updated url"}
  @invalid_attrs %{hash: nil, url: nil}

  def fixture(:link) do
    {:ok, link} = Links.create_link(@create_attrs)
    link
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all links", %{conn: conn} do
      conn = get conn, link_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create link" do
    test "renders link when data is valid", %{conn: conn} do
      conn = post conn, link_path(conn, :create), link: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, link_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "hash" => "some hash",
        "url" => "some url"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, link_path(conn, :create), link: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update link" do
    setup [:create_link]

    test "renders link when data is valid", %{conn: conn, link: %Link{id: id} = link} do
      conn = put conn, link_path(conn, :update, link), link: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, link_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "hash" => "some updated hash",
        "url" => "some updated url"}
    end

    test "renders errors when data is invalid", %{conn: conn, link: link} do
      conn = put conn, link_path(conn, :update, link), link: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete link" do
    setup [:create_link]

    test "deletes chosen link", %{conn: conn, link: link} do
      conn = delete conn, link_path(conn, :delete, link)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, link_path(conn, :show, link)
      end
    end
  end

  defp create_link(_) do
    link = fixture(:link)
    {:ok, link: link}
  end
end
