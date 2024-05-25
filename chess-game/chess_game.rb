module Chess
  RANKS = (1..8).freeze
  FILES = ('A'..'H').freeze

  def self.valid_square?(rank, file)
    RANKS.include?(rank) && FILES.include?(file)
  end

  def self.nick_name(first_name, last_name)
    "#{first_name[0..1]}#{last_name[-2..]}".upcase
  end

  def self.move_message(first_name, last_name, square)
    file = square[0]
    rank = square[1].to_i
    player = nick_name(first_name, last_name)

    if FILES.include?(file) && RANKS.include?(rank)
      "#{player} moved to #{square}"
    else
      "#{player} attempted to move to #{square}, but that is not a valid square"
    end
  end
end
