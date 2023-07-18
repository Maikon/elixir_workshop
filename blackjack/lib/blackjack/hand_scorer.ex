defmodule Blackjack.HandScorer do
  alias Blackjack.Deck

  @valid_cards Deck.generate()
  @aces ["AS", "AC", "AH", "AD"]
  @face_cards [
    "KS",
    "KC",
    "KH",
    "KD",
    "QS",
    "QC",
    "QH",
    "QD",
    "JS",
    "JC",
    "JH",
    "JD",
  ]

  def score(hand) do
    Enum.reduce(hand, 0, fn card, total ->
      total + get_numerical_value(card)
    end)
    |> evaluate_aces(hand)
  end

  defp get_numerical_value(card) when card not in @valid_cards, do: 0
  defp get_numerical_value(card) when card in @aces, do: 11
  defp get_numerical_value(card) when card in @face_cards, do: 10
  defp get_numerical_value(card) do
    [value, _suite] = card
    |> String.split(~r{S|C|D|H}, include_captures: true, trim: true)

    String.to_integer(value)
  end

  defp evaluate_aces(total_score, hand) do
    if total_score > 21 do
      aces =
        hand
        |> Enum.filter(fn card -> card in @aces end)
      |> Enum.count()

      total_score - aces * 10
    else
      total_score
    end
  end
end
