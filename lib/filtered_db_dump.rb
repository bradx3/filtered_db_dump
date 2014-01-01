require "filtered_db_dump/version"

module FilteredDbDump
  class Dumper

    attr_accessor :output_dir
    attr_accessor :mysql_options
    attr_accessor :db_connection
    attr_accessor :column_filters
    attr_accessor :table_filters
    attr_accessor :post_dump_command

    # Expected options:
    # :output_dir: A folder to dump filtered sql files into. This folder will be emptied before running the dump.
    # :mysql_options: Command line options to pass mysql (e.g. -u root some_db_name).
    # :db_connection: An active record connection to the database to dump.
    # :column_filters: A hash of column types to filter mapped to an array of values to filter on.
    # :table_filters: An array of tables names that should have *all* data filtered out.
    def initialize(options = {})
      self.output_dir = options[:output_dir]
      self.mysql_options = options[:mysql_options]
      self.db_connection = options[:db_connection]
      self.column_filters = (options[:column_filters] || {}).stringify_keys!
      self.table_filters = (options[:table_filters] || []).map(&:to_s)
    end

    # Run the dump. Call this method for a good time.
    def run
      tables.each do |table|
        dump_table(table)
      end
    end

    # Execute the mysqldump command for the given table.
    # Any column or table filters will be applied.
    def dump_table(table)
      conditions = conditions_for(table)

      cmd = "mysqldump #{ mysql_options } --tables #{ table }"
      cmd += " \"--where=#{ conditions }\"" if conditions.present?

      if post_dump_command
        cmd += "| #{post_dump_command}"
      end

      cmd += " > #{ output_dir }/#{ table }.sql"

      system(cmd)
    end

    # Return a string suitable for use in the mysqldump command line
    # --where option.
    def conditions_for(table)
      conditions = []

      column_filters.keys.each do |type|
        conditions << column_filter_conditions_for(table, type)
      end

      # exclude all rows from table filtered tables
      conditions << '1 = 0' if table_filters.include?(table)

      conditions.compact.join(' or ')
    end

    # Any conditions that should be used to filter table based on type
    def column_filter_conditions_for(table, type)
      values = column_filters[type].join(', ')
      foreign_key = type.singularize.foreign_key

      if table == type
        "\\`id\\` in (#{ values })"
      elsif columns_for(table).include?(foreign_key)
        "\\`#{ foreign_key }\\` in (#{ values })"
      end
    end

    # A list of all tables in the db
    def tables
      db_connection.select_values("show tables")
    end

    # A list of all columns for table
    def columns_for(table)
      db_connection.select_values("show columns from `#{ table }`")
    end

  end

end
