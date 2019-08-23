defmodule ExEarlyRetTest do
  use ExUnit.Case
  doctest ExEarlyRet
  import ExEarlyRet

  test "with single value" do
    assert quote(do: 1) ==
             (quote do
                earlyret(do: 1)
              end)
             |> Macro.expand_once(__ENV__)
  end

  test "with two statements" do
    assert (quote do
              a = 1
              "hi #{a}"
            end) ==
             (quote do
                earlyret do
                  a = 1
                  "hi #{a}"
                end
              end)
             |> Macro.expand_once(__ENV__)
  end

  test "with one ret_if" do
    assert (quote do
              if 1 == 2 do
                1
              else
                2
              end
            end)
           |> Macro.to_string() ==
             (quote do
                earlyret do
                  ret_if 1 == 2 do
                    1
                  end

                  2
                end
              end)
             |> Macro.expand_once(__ENV__)
             |> Macro.to_string()
  end

  test "with two ret_if" do
    assert (quote do
              if 1 == 2 do
                1
              else
                if a && b != c do
                  2
                else
                  3
                end
              end
            end)
           |> Macro.to_string() ==
             (quote do
                earlyret do
                  ret_if 1 == 2 do
                    1
                  end

                  ret_if a && b != c do
                    2
                  end

                  3
                end
              end)
             |> Macro.expand_once(__ENV__)
             |> Macro.to_string()
  end

  test "with two ret_if and vars" do
    assert (quote do
              one = 1 + 1

              if 1 == 2 do
                1
              else
                two = 2 + 2

                if a && b != c do
                  three = 3 + 3
                  2 + two + three
                else
                  two
                end
              end
            end)
           |> Macro.to_string() ==
             (quote do
                earlyret do
                  one = 1 + 1

                  ret_if 1 == 2 do
                    1
                  end

                  two = 2 + 2

                  ret_if a && b != c do
                    three = 3 + 3
                    2 + two + three
                  end

                  two
                end
              end)
             |> Macro.expand_once(__ENV__)
             |> Macro.to_string()
  end
end
