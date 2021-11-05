defmodule Blackjack.HandScorer do
  alias Blackjack.Deck

  @valid_cards Deck.generate()

  def score(hand) do
    Enum.reduce(hand, 0, fn card, total ->
      total + get_numerical_value(card)
    end)
    |> evaluate_aces(hand)
  end

  defp get_numerical_value("A"), do: 11
  defp get_numerical_value(card) when card in ["J", "Q", "K"], do: 10
  defp get_numerical_value(card) when card not in @valid_cards, do: 0
  defp get_numerical_value(card), do: String.to_integer(card)

  defp evaluate_aces(total_score, hand) do
    if total_score > 21 do
      aces =
        hand
        |> Enum.filter(fn card -> card == "A" end)
        |> Enum.count()

      total_score - aces * 10
    else
      total_score
    end
  end
end
