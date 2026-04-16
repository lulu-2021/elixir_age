defmodule ElixirAgeTest do
  use ExUnit.Case

  describe "ElixirAge API" do
    test "can generate keypair" do
      {:ok, {pub, sec}} = ElixirAge.generate_keypair()
      assert is_binary(pub)
      assert is_binary(sec)
      # Bech32 encoded keys are longer than 32 bytes
      assert byte_size(pub) > 0
      assert byte_size(sec) > 0
      # Keys should start with age1 and AGE-SECRET-KEY- respectively
      assert String.starts_with?(pub, "age1")
      assert String.starts_with?(sec, "AGE-SECRET-KEY-")
    end

    test "generate_keypair returns different keys each time" do
      {:ok, {pub1, sec1}} = ElixirAge.generate_keypair()
      {:ok, {pub2, sec2}} = ElixirAge.generate_keypair()
      refute pub1 == pub2
      refute sec1 == sec2
    end
  end

  describe "Core key derivation" do
    test "HKDF-SHA256 works" do
      ikm = :crypto.strong_rand_bytes(32)
      info = "test-info"
      length = 32

      {:ok, key1} = ElixirAge.Core.KeyDerivation.hkdf_sha256(ikm, info, length)
      {:ok, key2} = ElixirAge.Core.KeyDerivation.hkdf_sha256(ikm, info, length)

      assert is_binary(key1)
      assert byte_size(key1) == length
      assert key1 == key2
    end

    test "random_salt generates random bytes" do
      salt1 = ElixirAge.Core.KeyDerivation.random_salt(16)
      salt2 = ElixirAge.Core.KeyDerivation.random_salt(16)

      assert is_binary(salt1)
      assert byte_size(salt1) == 16
      assert salt1 != salt2
    end
  end

  describe "ChaCha20-Poly1305" do
    test "encrypt and decrypt round trip" do
      plaintext = "Hello, Age!"
      key = :crypto.strong_rand_bytes(32)

      {:ok, ciphertext} = ElixirAge.Encryption.ChaCha20.encrypt(plaintext, key)
      {:ok, decrypted} = ElixirAge.Encryption.ChaCha20.decrypt(ciphertext, key)

      assert decrypted == plaintext
    end

    test "encryption with AAD" do
      plaintext = "Secret message"
      key = :crypto.strong_rand_bytes(32)
      aad = "additional-authenticated-data"

      {:ok, ciphertext} = ElixirAge.Encryption.ChaCha20.encrypt(plaintext, key, aad)
      {:ok, decrypted} = ElixirAge.Encryption.ChaCha20.decrypt(ciphertext, key, aad)

      assert decrypted == plaintext
    end

    test "decryption fails with wrong key" do
      plaintext = "Secret"
      key1 = :crypto.strong_rand_bytes(32)
      key2 = :crypto.strong_rand_bytes(32)

      {:ok, ciphertext} = ElixirAge.Encryption.ChaCha20.encrypt(plaintext, key1)
      result = ElixirAge.Encryption.ChaCha20.decrypt(ciphertext, key2)

      assert {:error, _} = result
    end
  end

  describe "Armor encoding" do
    test "encode and decode round trip" do
      data = "test data"
      {:ok, armored} = ElixirAge.Encryption.Armor.encode(data)

      assert String.contains?(armored, "-----BEGIN AGE ENCRYPTED FILE-----")
      assert String.contains?(armored, "-----END AGE ENCRYPTED FILE-----")

      {:ok, decoded} = ElixirAge.Encryption.Armor.decode(armored)
      assert decoded == data
    end
  end

  describe "Core format" do
    test "parse magic bytes" do
      data = "age-encryption.org/v1\nrest of file"
      {:ok, parsed} = ElixirAge.Core.Format.parse(data)

      assert parsed.version == 1
      assert is_list(parsed.stanzas)
    end

    test "invalid format returns error" do
      {:error, msg} = ElixirAge.Core.Format.parse("invalid data")
      assert msg == "invalid_age_format"
    end
  end
end
