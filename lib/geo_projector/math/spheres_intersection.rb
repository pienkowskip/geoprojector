require_relative 'polynomials_system'

module GeoProjector::Math
  class SpheresIntersection < PolynomialsSystem
    def initialize(c1, r1, c2, r2, c3, r3)
      super(2, 3, 3)
      input = [[[*c1], r1], [[*c2], r2], [[*c3], r3]]
      rows = @matrix.to_enum
      mapping = [[4, 1, 0],
                 [7, 2, 0],
                 [9, 3, 0]]
      input.each do |point, distance|
        raise ArgumentError, 'invalid point dimensions' unless point.size == 3
        point.map! &method(:Float)
        distance = Float(distance)
        raise ArgumentError, 'negative sphere radius' if distance <= 0
        row = rows.next
        mapping.zip(point).each do |indexes, coor|
          indexes.zip(sum_square(1, -coor)).each { |i, v| row[i] += v }
        end
        row[0] -= distance ** 2
      end
    end

    def roots!
      return @roots unless @roots.nil?
      solve!
    end

    private

    # TODO: Write more general solving method. Currently it can fail for a proper equations system.
    def solve!
      mapping = [4, 7, 9]
      @matrix[0..2].each { |row| mapping.each { |idx| raise 'invalid equations system' unless (1 - row.fetch(idx)).zero_eps? }}

      first = @matrix.fetch(0)
      second = @matrix.fetch(1)
      third = @matrix.fetch(2)

      @matrix[1..2].each { |row| row.subtract!(first) }
      second.normalize_term!(2)
      third.normalize_term!(2).subtract!(second) unless third.fetch(2).zero_eps?
      third.normalize_term!(3)
      second.normalize_term!(3).subtract!(third).normalize_term!(2) unless second.fetch(3).zero_eps?

      mapping = [4, 1, 0]
      {1 => 7, 2 => 9}.each do |ri, ci|
        row = @matrix.fetch(ri)
        mapping.zip(sum_square(row.fetch(1), row.fetch(0))).each do |idx, val|
          first[idx] += val
        end
        first[ci] -= 1.0
      end

      first.normalize_term!(2).subtract!(second) unless first.fetch(2).zero_eps?
      first.normalize_term!(3).subtract!(third) unless first.fetch(3).zero_eps?
      first.normalize_term!(4)

      coefs = mapping.map { |idx| first.fetch(idx) }
      mapping = Set.new(mapping)
      first.each_with_index { |val, idx| raise 'calculating error' unless mapping.include?(idx) || val.zero_eps? }
      delta = coefs[1] ** 2 - 4 * coefs[0] * coefs[2]
      raise 'negative or zero discriminant' if delta <= 0 || delta.zero_eps?
      delta = Math.sqrt(delta)

      root_x = ->(delta_sqrt) { (delta_sqrt - coefs[1]) / (2 * coefs[0]) }
      root_yz = ->(x, row) { -(row.fetch(0) + x * row.fetch(1)) }
      @roots = [delta, -delta].map do |x|
        x = root_x.call(x)
        [x, root_yz.call(x, second), root_yz.call(x, third)]
      end
    end

    def sum_square(a, b)
      return a ** 2.0, 2.0 * a * b, b ** 2.0
    end
  end
end