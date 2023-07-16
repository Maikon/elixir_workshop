defmodule Blackjack.Deck do
  @card_suites ["D", "H", "C", "S"]
  @face_cards ["A", "K", "Q", "J"]
  @numeral_cards Enum.map(2..10, &to_string/1)

  def generate do
    @card_suites
    |> Enum.reduce([], fn suite, cards ->
      face_cards = Enum.map(@face_cards, &(&1 <> suite))
      numeral_cards = Enum.map(@numeral_cards, &(&1 <> suite))

      cards ++ face_cards ++ numeral_cards
    end)
    |> shuffle()
  end

  def shuffle(deck), do: Enum.shuffle(deck)

  def deal_card([card | rest]), do: {card, rest}
  def deal_card({_first, rest}), do: deal_card(rest)
end
