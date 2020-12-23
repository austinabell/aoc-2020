defmodule Day22 do
  def run do
    players = parse()
    cards = combat(players)
    IO.inspect(score(cards))

    {_, cards} = recursive_combat(players)
    IO.inspect(score(cards))
  end

  # Part 1:
  def combat({[], p2}), do: p2
  def combat({p1, []}), do: p1

  def combat({[p1 | d1], [p2 | d2]}) do
    sorted = Enum.sort([p1, p2]) |> Enum.reverse()

    if p1 > p2 do
      combat({d1 ++ sorted, d2})
    else
      combat({d1, d2 ++ sorted})
    end
  end

  # Part 2:
  def rc_round({[p1 | d1], [p2 | d2]}) do
    cond do
      length(d1) >= p1 and length(d2) >= p2 ->
        case recursive_combat({Enum.take(d1, p1), Enum.take(d2, p2)}) do
          {:p1, _} -> {d1 ++ [p1, p2], d2}
          {:p2, _} -> {d1, d2 ++ [p2, p1]}
        end

      p1 >= p2 ->
        {d1 ++ [p1, p2], d2}

      :else ->
        {d1, d2 ++ [p2, p1]}
    end
  end

  def recursive_combat(state, history \\ MapSet.new())
  def recursive_combat({[], d2}, _), do: {:p2, d2}
  def recursive_combat({d1, []}, _), do: {:p1, d1}

  def recursive_combat({d1, d2} = state, history) do
    if state in history do
      {:p1, d1 ++ d2}
    else
      recursive_combat(rc_round(state), MapSet.put(history, state))
    end
  end

  def score(lst) do
    lst
    |> Enum.reduce({length(lst), 0}, fn e, {i, s} -> {i - 1, s + e * i} end)
    |> elem(1)
  end

  def parse do
    contents = File.read!("input.txt")
    [p1, p2] = contents |> String.split("\n\n") |> Enum.map(&parse_player/1)
    {p1, p2}
  end

  def parse_player(<<"Player ", _, ":\n", rest::binary>>) do
    rest |> String.trim() |> String.split("\n") |> Enum.map(&String.to_integer/1)
  end
end

Day22.run()
