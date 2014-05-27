require 'rspec'
require 'sqlite3'
Dir[File.dirname(__FILE__) + '/../lib/findporn/*'].each {|file| require file.gsub('file:', '') }

describe SqlClient do

  TEST_DOC_SQL_CLIENT =
      '@section name="section1" append="append1"' + "\n"\
        'query1' + "\n"\
        'query2' + "\n"\
        '@section name="section2" append="append2"' + "\n"\
        'query3' + "\n"\
        'query4' + "\n"\
        'query5' + "\n"

  it 'saves PornStore' do
    database_stub = double(SQLite3::Database)
    sql_client = SqlClient.new database_stub

    sql_client.should_receive(:save_section) do |session|
      session.name == 'section1'
    end
    sql_client.should_receive(:save_section) do |session|
      session.name == 'section2'
    end

    sql_client.save_porn_store get_porn_store_stub
  end

  #noinspection RubyArgCount
  it 'saves Section' do
    database_stub = double(SQLite3::Database).stub(:execute).and_return('')
    sql_client = SqlClient.new database_stub

    section = Section.new('stub_section_name', 'stub_section_appendix')
    section.add_query Query.new('stub_query_value', section)

    sql_client.should_receive(:save_query) do |query|
      query.value == 'stab_query_value'
    end

    sql_client.save_section section
  end

  private

  def get_porn_store_stub
    queries_doc = QueriesDoc.from_string TEST_DOC_SQL_CLIENT
    pornolab_client = double(PornolabClient)
    pornolab_client.stub(:find_hrefs).and_return( [Href.new('stub_title', 'stub_url')])
    PornStore.create(queries_doc, pornolab_client)
  end
end
