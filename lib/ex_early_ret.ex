defmodule ExEarlyRet do
  @moduledoc """
  Macro for limited early return (expands into if-else chains).
  """

  def ret_if({:nooooo_dont, :use_this}, {:outside_the, :macros}), do: nil

  defp retfold([{:ret_if, ctx, [con, [do: bod]]} | tl], acc) do
    retfold([], [{:if, ctx, [con, [do: bod, else: {:__block__, ctx, retfold(tl, [])}]]} | acc])
  end

  defp retfold([hd | tl], acc), do: retfold(tl, [hd | acc])
  defp retfold([], acc), do: Enum.reverse(acc)

  defp retwrap({:__block__, [], stmts}), do: {:__block__, [], retfold(stmts, [])}
  defp retwrap(x), do: x

  defmacro earlyret(do: expr), do: retwrap(expr)

  defmacro defearlyret(call, do: expr) do
    quote do
      def unquote(call), do: unquote(retwrap(expr))
    end
  end

  defmacro defpearlyret(call, do: expr) do
    quote do
      defp unquote(call), do: unquote(retwrap(expr))
    end
  end
end
