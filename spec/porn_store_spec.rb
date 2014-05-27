require 'rspec'
Dir[File.dirname(__FILE__) + '/../lib/findporn/*'].each {|file| require file.gsub('file:', '') }

describe PornStore do

  it 'loads PornStore' do
    input =
        '@section name="section1" append="append1"' + "\n"\
        'query1' + "\n"\
        'query2' + "\n"\
        '@section name="section2" append="append2"' + "\n"\
        'query3' + "\n"\
        'query4' + "\n"\
        'query5' + "\n"

    queries_doc = QueriesDoc.from_string input

    pornolab_client = double(PornolabClient)
    pornolab_client.stub(:find_hrefs).and_return( Href.new('stub_title', 'stub_url'))

    porn_store = PornStore.create(queries_doc, pornolab_client)

    porn_store.sections.length.should == queries_doc.sections.length

    porn_store.sections[0].queries_to_hrefs[0][:hrefs].title.should == 'stub_title'
    porn_store.sections[0].queries_to_hrefs[0][:hrefs].url.should == 'stub_url'
  end
end
