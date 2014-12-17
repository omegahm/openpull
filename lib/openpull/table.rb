module OpenPull
  class Table
    HEADINGS = %w(title user labels status mergeable url updated)

    class << self
      def rewind!
        print "\r"
      end

      def show(sub_tables)
        rewind!

        Terminal::Table.new(headings: HEADINGS.map(&:bold)) do |tab|
          sub_tables.each_with_index do |sub_table, j|
            sub_table.each_with_index do |row, i|
              tab.add_separator if i == 0 && j != 0
              tab.add_row row
            end
          end
        end
      end
    end
  end
end
