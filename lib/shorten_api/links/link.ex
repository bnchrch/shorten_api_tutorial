defmodule HashId do
  @behaviour Ecto.Type
  @hash_id_length 8
  # ======================= #
  # Ecto Specific Callbacks #
  # ======================= #

  @doc "Called when creating an Ecto.Changeset"
  @spec cast(any) :: Map.t
  def cast(value), do: hash_id_format(value)

  @doc "Converts/accepts a value that has been directly placed into the ecto struct after a changeset"
  @spec dump(any) :: Map.t
  def dump(value), do: hash_id_format(value)

  @doc "Converts a value from the database into the HashId type"
  @spec load(any) :: Map.t
  def load(value), do: hash_id_format(value)

  @doc "Callback invoked by autogenerate fields."
  @spec autogenerate() :: String.t
  def autogenerate, do: generate()

  @doc "The Ecto type."
  def type, do: :string

  # ============ #
  # Custom Logic #
  # ============ #

  @spec hash_id_format(any) :: Map.t
  def hash_id_format(value) do
    case validate_hash_id(value) do
      true -> {:ok, value}
      _ -> {:error, "'#{value}' is not a string"}
    end
  end

  @doc "Validate the given value as a string"
  def validate_hash_id(string) when is_binary(string), do: true
  def validate_hash_id(other), do: false

  @doc "Generates a HashId"
  @spec generate() :: String.t
  def generate do
    @hash_id_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64
    |> binary_part(0, @hash_id_length)
  end
end


defmodule ShortenApi.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  # TODO
  # - make hashid auto gen
  # - check for exisitng url
  # - look up limits for mnesia
  # setup auth
  # setup login
  @primary_key {:hash, HashId, [autogenerate: true]}
  @derive {Phoenix.Param, key: :hash}
  schema "links" do
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
