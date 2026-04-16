# ElixirAge

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_age` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_age, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/elixir_age>.


## Usage

### As a Library

```elixir
# Generate a keypair
{:ok, {public_key, secret_key}} = Age.generate_keypair()

# Encrypt to recipients
recipients = ["age1..."]
{:ok, encrypted} = Age.encrypt(data, recipients, armor: true)

# Decrypt
{:ok, decrypted} = Age.decrypt(encrypted, identity_file)

### As a Cli

# Encrypt a file
$ rage -r age1... -o secret.age myfile.txt

# Decrypt a file
$ rage -d -i ~/.age/key -o myfile.txt secret.age
