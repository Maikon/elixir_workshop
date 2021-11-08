defmodule Blackjack.Deck do
  @face_cards ["A", "K", "Q", "J"]
  @numeral_cards Enum.map(2..10, &to_string/1)

  def generate do
    1..4
    |> Enum.reduce([], fn _, cards ->
      cards ++ @face_cards ++ @numeral_cards
    end)
    |> shuffle()
  end

  def shuffle(deck), do: Enum.shuffle(deck)

  def deal_card([card | rest]), do: {card, rest}
  def deal_card({_first, rest}), do: deal_card(rest)
end
