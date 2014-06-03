require 'rspec'
Dir[File.dirname(__FILE__) + '/../lib/findporn/*'].each {|file| require file.gsub('file:', '') }

describe PornStore do

  TEST_DOC_PORN_STORE =
      '@section name="section1" append="append1"' + "\n"\
        'query1' + "\n"\
        'query2' + "\n"\
        '@section name="section2" append="append2"' + "\n"\
        'query3' + "\n"\
        'query4' + "\n"\
        'query5' + "\n"

  it 'loads PornStore' do
    queries_doc = QueriesDoc.from_string TEST_DOC_PORN_STORE

    pornolab_client = double(PornolabClient)
    pornolab_client.stub(:find_hrefs).and_return( [Href.new('stub_title', 'stub_url', nil, nil, nil, nil, true)])

    porn_store = PornStore.create(queries_doc, pornolab_client)

    porn_store.sections.length.should == queries_doc.sections.length

    porn_store.sections[0].queries[0].hrefs[0].title.should == 'stub_title'
    porn_store.sections[0].queries[0].hrefs[0].url.should == 'stub_url'
  end

  it 'saves PornStore' do
    queries_doc = QueriesDoc.from_string TEST_DOC_PORN_STORE
    pornolab_client = double(PornolabClient)
    pornolab_client.stub(:find_hrefs).and_return( [Href.new('stub_title', 'stub_url', nil, nil, nil, nil, true)])
    porn_store = PornStore.create(queries_doc, pornolab_client)

    sql_client = double(SqlClient)
    sql_client.should_receive(:save_porn_store).with(porn_store)
    porn_store.save sql_client
  end
end
