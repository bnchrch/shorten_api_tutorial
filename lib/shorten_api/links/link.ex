defmodule ShortenApi.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset


  schema "links" do
    field :hash, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:hash, :url])
    |> validate_required([:hash, :url])
    |> unique_constraint(:hash)
    |> unique_constraint(:url)
  end
end
