[![hex.pm version](https://img.shields.io/hexpm/v/ex_early_ret.svg?style=flat)](https://hex.pm/packages/ex_early_ret)
[![hex.pm downloads](https://img.shields.io/hexpm/dt/ex_early_ret.svg?style=flat)](https://hex.pm/packages/ex_early_ret)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](https://hexdocs.pm/ex_early_ret/)
[![unlicense](https://img.shields.io/badge/un-license-green.svg?style=flat)](http://unlicense.org)

# ex_early_ret

An [Elixir] macro for limited early return (expands to nested if-else).

Limited in that you can't return from nested blocks, it's strictly for this kind of thing:

```ruby
if some_check(a, b)
  return -1
end

some_var = a + b

if other_check(some_var) && aaaaa
  return -2
end

some_other_vars = 123 # ...
```

You could sort of use `cond` for this kind of validation code, but `cond` does not let you define the `some_var` above.

[Elixir]: https://elixir-lang.org

## Installation

Add ex_early_ret to your project's dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_early_ret, "~> 0.1.0"}
  ]
end
```

And fetch your project's dependencies:

```shell
$ mix deps.get
```

## Usage

Some examples:

```elixir
defearlyret fetch(url, check_mention: check_mention) do
  u = URI.parse(url)

  ret_if u.scheme != "http" && u.scheme != "https", do: {:non_http_scheme, u.scheme}

  host = u.host

  ret_if host == nil || host == "localhost" do
    {:local_host, host}
  end

  resp = HttpClient.get!(url, headers: [{"accept", "text/html"}])
  Floki.parse(resp.body)
end
```

```elixir
{status, body} =
  earlyret do
    redir = conn.body_params["redirect_uri"]

    ret_if is_nil(redir) or !String.starts_with?(redir, "http"),
      do: {:bad_request, "No valid redirect URI"}

    clid = conn.body_params["client_id"]

    ret_if is_nil(clid), do: {:bad_request, "No client ID"}

    ret_if is_nil(conn.body_params["code"]), do: {:bad_request, "No code"}

    tempcode = TempCode.get_if_valid(conn.body_params["code"])

    ret_if is_nil(tempcode), do: {:bad_request, "Code is not valid"}

    ret_if tempcode.redirect_uri != redir,
      do:
        {:bad_request,
         "redirect_uri does not match: '#{redir}' vs '#{tempcode.redirect_uri}'"}

    ret_if tempcode.client_id != clid,
      do: {:bad_request, "client_id does not match: '#{clid}' vs '#{tempcode.client_id}'"}

    TempCode.use(tempcode.code)

    Jason.encode(%{
      me: Process.get(:our_home_url)
    })
  end
```

## Contributing

Please feel free to submit pull requests!

By participating in this project you agree to follow the [Contributor Code of Conduct](https://contributor-covenant.org/version/1/4/).

[The list of contributors is available on GitHub](https://github.com/myfreeweb/ex_early_ret/graphs/contributors).

## License

This is free and unencumbered software released into the public domain.  
For more information, please refer to the `UNLICENSE` file or [unlicense.org](https://unlicense.org).
