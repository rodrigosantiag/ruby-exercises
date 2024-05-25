class Alphametics
  def self.solve(puzzle)
    new(puzzle).solve
  end

  attr_reader :words, :leading_letter

  def initialize(puzzle)
    @words = puzzle.scan(/[A-Z]+/)
    @leading_letter = words.max_by(&:length).each_char.first
  end

  def solve
    (1..9).each do |n|
      ((0..9).to_a - [n]).permutation(linear_equation.count - 1) do |permutation|
        next unless permutation.unshift(n)
                               .zip(equation_coefficients)
                               .sum { |x, y| x * y }
                               .zero?

        return equation_letters.zip(permutation).to_h
      end
    end

    {}
  end

  private

  def equation_coefficients
    @equation_coefficients ||= linear_equation.map(&:last)
  end

  def equation_letters
    @equation_letters ||= linear_equation.map(&:first)
  end

  # Transform the string equation into a linear equation with coefficients.
  # Then sorts so the leading letter is first. Here A will be first.
  # => ACA + DD == BD
  # => ACA + DD - BD == 0
  # => 101*A - 10*B + 10*C + 10*D == 0
  # => { 'A' => 101, 'B' => -10, 'C' => 10, 'D' => 10 }
  # => [['A', 101], ['B', -10], ['C', 10], ['D', 10]]
  def linear_equation
    @linear_equation ||= begin
                           *addends, expectation = words

                           result = Hash.new { |h, k| h[k] = 0 }

                           addends.each do |coeff|
                             coeff.reverse.each_char.with_index do |letter, power|
                               result[letter] += 10 ** power
                             end
                           end

                           expectation.reverse.each_char.with_index do |letter, power|
                             result[letter] -= 10 ** power
                           end

                           result.sort_by { |(k,v)| leading_letter == k ? -1 : 1 }
                         end
  end
end
