defmodule ShortenApi.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:hash, :string, []}
  @derive {Phoenix.Param, key: :hash}
  schema "links" do
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
