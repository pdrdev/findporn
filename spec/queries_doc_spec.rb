require 'rspec'
Dir[File.dirname(__FILE__) + '/../lib/findporn/*'].each {|file| require file.gsub('file:', '') }

describe QueriesDoc do

  it "2 empty sections" do
    input =
        '@section name="section1" append="append1"' + "\n"\
        '@section name="section2" append="append2"' + "\n"
    queries_doc = QueriesDoc.from_string input
    sections = queries_doc.sections

    sections.length.should == 2

    sections[0].queries.length.should == 0
    sections[0].name.should == 'section1'
    sections[0].append.should == 'append1'

    sections[1].queries.length.should == 0
    sections[1].name.should == 'section2'
    sections[1].append.should == 'append2'
  end

  it "1 section with queries" do
    input =
        '@section name="section1" append="append1"' + "\n"\
        'query1' + "\n"\
        'query2'

    queries_doc = QueriesDoc.from_string input
    sections = queries_doc.sections

    sections.length.should == 1

    sections[0].queries.length.should == 2
    sections[0].name.should == 'section1'
    sections[0].append.should == 'append1'

    sections[0].queries[0].should == 'query1'
    sections[0].queries[1].should == 'query2'
  end

  it "ignore empty lines and comments" do
    input =
        '       ' + "\n"\
        'query1 #lalala ' + "\n"\
        ' #lalala       '

    queries_doc = QueriesDoc.from_string input
    sections = queries_doc.sections

    sections.length.should == 1

    sections[0].queries.length.should == 1
    sections[0].name.should == ''
    sections[0].append.should == ''

    sections[0].queries[0].should == 'query1'
  end

  it "counts queries" do
    input =
        '@section name="section1" append="append1"' + "\n"\
        'query1' + "\n"\
        'query2' + "\n"\
        '@section name="section2" append="append2"' + "\n"\
        'query3' + "\n"\
        '' + "\n"\
        '# some comment' + "\n"\
        '   # another comment' + "\n"\
        'query4' + "\n"\
        'query5' + "\n"

    queries_doc = QueriesDoc.from_string input
    queries_doc.size.should == 5
  end

end
