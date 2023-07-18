defmodule Blackjack.HandScorer do
  alias Blackjack.Deck

  @valid_cards Deck.generate()
  @aces Deck.aces(@valid_cards)
  @face_cards Deck.face_cards(@valid_cards)

  def score(hand) do
    hand
    |> Enum.reduce(0, fn card, total ->
      total + get_numerical_value(card)
    end)
    |> evaluate_aces(hand)
  end

  defp get_numerical_value(card) when card not in @valid_cards, do: 0
  defp get_numerical_value(card) when card in @aces, do: 11
  defp get_numerical_value(card) when card in @face_cards, do: 10
  defp get_numerical_value(card) do
    [value, _suite] = Deck.separate_value_and_suite(card)

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
