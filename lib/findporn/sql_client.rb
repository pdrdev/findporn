require_relative 'util.rb'

class SqlClient
  DB_FILE_NAME = Util.root + 'fp.db'
  TABLE_NAMES = ['sections', 'hrefs', 'queries']

  def self.create
    db = SQLite3::Database.new DB_FILE_NAME
    client = SqlClient.new db
    if !client.consistent?
      client.bootstrap
    end
    client
  end

  def initialize(db)
    @db = db
  end

  def save_porn_store(porn_store)
    set_everything_inactive
    porn_store.sections.each { |section| save_section(section) }
  end

  def save_section(section)
    section_id = get_section_id(section)
    if section_id.nil?
      section_id = insert_section(section)
    else
      set_section_active(section_id)
    end
    section.id = section_id

    section.queries.each { |query| save_query(query) }
  end

  def save_query(query)
    query_id = get_query_id(query)
    if query_id.nil?
      query_id = insert_query(query)
    else
      set_query_active(query_id)
    end
    query.id = query_id

    query.hrefs.each { |href| save_href(href) }
  end

  def save_href(href)
    href_id = get_href_id(href)
    if href_id.nil?
      href_id = insert_href(href)
    else
      set_href_active(href_id)
    end
    href.id = href_id
  end

  def get_section_id(section)
    result = @db.execute "SELECT rowid FROM sections WHERE name='#{section.name}'"
    if result.empty?
      return nil
    end
    result[0][0]
  end

  def get_query_id(query)
    result = @db.execute("SELECT rowid FROM queries WHERE value = ? AND section_id = ?", query.value, query.section.id)
    if result.empty?
      return nil
    end
    result[0][0]
  end

  def get_href_id(href)
    result = @db.execute("SELECT rowid FROM hrefs WHERE title = ? AND query_id=  ? ", href.title, href.query.id)
    if result.empty?
      return nil
    end
    result[0][0]
  end

  def insert_section(section)
    @db.execute("INSERT INTO sections(name, appendix, active) VALUES (?, ?, ?)", section.name, section.append, if section.active then 1 else 0 end)
    get_last_rowid
  end

  def insert_query(query)
    @db.execute("INSERT INTO queries(section_id, value, active) VALUES (?, ?, ?)", query.section.id, query.value, if query.active then 1 else 0 end)
    get_last_rowid
  end

  def insert_href(href)
    q = "INSERT INTO hrefs(query_id, title, url, size, size_raw, active, uploaded_timestamp, added_timestamp) VALUES (
      ?, ?, ?, ?, ?, ?, ?, ?)"
    @db.execute(q, href.query.id, href.title, href.url, href.size.to_i, href.size_raw, if href.active then 1 else 0 end, href.uploaded_timestamp.to_i, href.added_timestamp.to_i)
    get_last_rowid
  end

  def get_last_rowid
    result = @db.execute "SELECT last_insert_rowid();"
    result[0][0]
  end

  def set_query_active(rowid)
    @db.execute('UPDATE queries SET active = 1 WHERE rowid = ?', rowid)
  end

  def set_section_active(rowid)
    @db.execute('UPDATE sections SET active = 1 WHERE rowid = ?', rowid)
  end

  def set_href_active(rowid)
    @db.execute('UPDATE hrefs SET active = 1 WHERE rowid = ?', rowid)
  end

  def set_everything_inactive
    @db.execute('UPDATE hrefs SET active = 0')
    @db.execute('UPDATE queries SET active = 0')
    @db.execute('UPDATE sections SET active = 0')
  end

  def load_porn_store
    PornStore.new(load_sections)
  end

  def load_sections
    @db.execute('SELECT rowid, name, appendix, active FROM sections').map do |row|
      section = Section.new(row[1], row[2], row[3] == 1)
      section.id = row[0]
      section.queries = load_queries(section)
      section
    end
  end

  def load_queries(section)
    @db.execute("SELECT rowid, value, active FROM queries where section_id=#{section.id}").map do |row|
      query = Query.new(row[1], section, row[2] == 1)
      query.id = row[0]
      query.hrefs = load_hrefs(query)
      query
    end
  end

  def load_hrefs(query)
    res = @db.execute("SELECT rowid, title, url, size, size_raw, active, uploaded_timestamp, added_timestamp FROM hrefs where query_id=#{query.id}").map do |row|
      href = Href.new(row[1], row[2], row[3], row[4], row[6], row[7], row[5] == 1, query)
      href.id = row[0]
      href
    end
    res.sort{|x, y| y.uploaded_timestamp <=> x.uploaded_timestamp }
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

  def bootstrap
    Util.log 'Bootstrapping database'

    Util.log 'Dropping all tables'
    drop_all_tables

    Util.log 'Creating table: sections'
    @db.execute('create table sections (name TEXT, appendix TEXT, active INTEGER);')

    Util.log 'Creating table: queries'
    @db.execute('create table queries (section_id INT, value TEXT, active INTEGER);')

    Util.log 'Creating table: hrefs'
    @db.execute('create table hrefs (query_id INTEGER, title TEXT, url TEXT, size INTEGER, size_raw TEXT, active INTEGER, uploaded_timestamp INTEGER, added_timestamp INTEGER);')

    Util.log 'Bootstrapping competed'
  end

  def drop_all_tables
    TABLE_NAMES.each { |table_name| @db.execute "drop table if exists #{table_name}" }
  end
end
