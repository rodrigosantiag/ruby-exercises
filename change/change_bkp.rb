module Change
  def self.generate(coins, change)
    coins = coins.select { |c| c <= change }
    coins.sort!.reverse!
    results = get_coins(coins, change, [])
    result = results.min_by(&:size)

    raise ImpossibleCombinationError if results.empty? || result.empty?

    result.sort!
  end

  def self.get_coins(coins, change, coins_set)
    current_change = change
    current_set = []

    coins.each_with_index do |coin, idx|
      if current_set.sum + coin <= change
        current_set << coin
        current_change -= coin
        remaining_coins = coins[idx+1..]

        while current_change.positive? && coin <= current_change
          break if (current_change - coin).positive? && !remaining_coins.empty? && (current_change - coin < remaining_coins.min || current_set.sum + coin >  change || !((current_set.sum + coin) % remaining_coins.min).zero?)
          current_set << coin
          current_change -= coin
        end
      end
    end

    coins_set << current_set if !current_set.empty? && current_set.sum == change
    get_coins(coins[1..coins.size], change, coins_set) unless coins[1..coins.size].empty?

    coins_set
  end
end

class ImpossibleCombinationError < StandardError; end
