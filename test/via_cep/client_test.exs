defmodule Rockelivery.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias Plug.Conn

  alias Rockelivery.Error
  alias Rockelivery.ViaCep.Client

  describe "get_cep_info/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "When there is a valid CEP, returns the cep info", %{bypass: bypass} do
      cep = "01001000"

      url = endpoint_url(bypass.port)

      body = ~s({
        "cep": "01001-000",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      })

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:ok, build(:cep_info)}

      assert response == expected_response
    end

    test "When the CEP is invalid, returns an error", %{bypass: bypass} do
      cep = "123"

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        conn
        |> Conn.resp(400, "")
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, Error.build(:bad_request, "CEP invalid!")}

      assert response == expected_response
    end

    test "When the CEP was not found, returns an error", %{bypass: bypass} do
      cep = "00000000"

      body = ~s({"erro": "true"})

      url = endpoint_url(bypass.port)

      Bypass.expect(bypass, "GET", "#{cep}/json", fn conn ->
        conn
        |> Conn.put_resp_header("content-type", "application/json")
        |> Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response = {:error, Error.build(:not_found, "CEP not found!")}

      assert response == expected_response
    end

    test "When there is a generic error, return an error", %{bypass: bypass} do
      cep = "00000000"

      url = endpoint_url(bypass.port)

      Bypass.down(bypass)

      response = Client.get_cep_info(url, cep)

      {:error, %Error{status: :bad_request}} = response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
