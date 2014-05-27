require_relative 'util.rb'

class SqlClient
  DB_FILE_NAME = Util.root + 'test.db'
  TABLE_NAMES = ['sections', 'hrefs', 'queries']

  def self.create
    db = SQLite3::Database.new DB_FILE_NAME
    client = SqlClient.new db
    if !client.consistent?
      client.bootstrap
    end
  end

  def initialize(db)
    @db = db
  end

  def bootstrap
    Util.log 'Bootstrapping database'

    Util.log 'Dropping all tables'
    drop_all_tables

    Util.log 'Creating table: sections'
    @db.execute('create table sections (id INTEGER PRIMARY KEY, name TEXT, appendix TEXT);')

    Util.log 'Creating table: queries'
    @db.execute('create table queries (id INTEGER PRIMARY KEY, section_id INT, value TEXT, appendix TEXT);')

    Util.log 'Creating table: hrefs'
    @db.execute('create table hrefs (id INTEGER PRIMARY KEY, query_id INTEGER, value TEXT, appendix TEXT, size INTEGER, size_raw TEXT);')

    Util.log 'Bootstrapping competed'
  end

  def drop_all_tables
    TABLE_NAMES.each { |table_name| @db.execute "drop table if exists #{table_name}" }
  end

  def consistent?
    Util.log 'Checking database consistency'

    consistent = true
    TABLE_NAMES.each do |table_name|
      q = "SELECT name FROM sqlite_master WHERE type='table' AND name='#{table_name}';"
      q_res = @db.execute q
      if q_res.empty? then
        consistent = false
        break
      end
    end

    Util.log (if consistent then 'Consistent' else 'Inconsistent' end)
    consistent
  end
end
