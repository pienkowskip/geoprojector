require_relative 'polynomial'

module GeoProjector::Math
  class PolynomialsSystem
    attr_reader :degree, :vars

    def initialize(degree, vars, size)
      @degree, @vars = Integer(degree), Integer(vars)
      vars_ids = @vars.times.to_a
      width = 1 + (1..@degree).map { |deg| vars_ids.repeated_combination(deg).count }.reduce(:+)
      @matrix = Integer(size).times.map { |_| Polynomial.new(width, 0.0) }
    end

    def size
      @matrix.size
    end

    def to_s(precision = 3)
      format = "% .#{Integer(precision)}f"
      rows = @matrix.map { |row| row.map { |elm| format % elm } }
      terms = nil
      if @vars <= 'z'.ord - 'a'.ord + 1
        terms = ['1']
        first = @vars > 3 ? 'a'.ord : 'x'.ord
        var_symbols = @vars.times.map { |id| (first + id).chr }
        (1..@degree).each do |degree|
          var_symbols.repeated_combination(degree).each do |term|
            hash = {}
            term.each { |sym| hash[sym] = hash.fetch(sym, 0) + 1 }
            terms << hash.map { |sym, count| count > 1 ? "#{sym}^#{count}" : sym }.join('*')
          end
        end
      end
      rows.unshift(terms) if terms
      max = 0
      rows.each { |row| row.each { |elm| max = elm.size if elm.size > max } }
      terms = !!terms
      rows.map! do |row|
        row.map! { |elm| elm.rjust(max) }
        row = row.join(' ')
        if terms
          terms = false
          '  ' << row << '  '
        else
          '[ ' << row << ' ]'
        end
      end
      "<#{self.class} degree=#{@degree} vars=#{@vars} matrix=\n#{rows.join("\n")}\n>"
    end

    protected

  end
end