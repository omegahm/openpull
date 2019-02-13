# frozen_string_literal: true

module OpenPull
  class Table
    HEADINGS = %w[
      title user labels status commits comments mergeable url updated
    ].freeze

    class << self
      def rewind!
        print "\r"
      end

      def show(sub_tables)
        rewind!

        Terminal::Table.new(headings: HEADINGS.map(&:bold)) do |tab|
          sub_tables.each_with_index do |sub_table, j|
            sub_table.each_with_index do |row, i|
              tab.add_separator if i.zero? && !j.zero?
              tab.add_row row
            end
          end
        end
      end
    end
  end
end
