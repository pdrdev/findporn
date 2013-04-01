class QueriesDoc
  attr_reader :sections

  def self.from_file_name(file_name)
    QueriesDoc.from_string(File.open(file_name).read)
  end

  def self.from_string(s)
    QueriesDoc.new s
  end

  def initialize(s)
    @sections = Array.new
    lines = s.lines
    lines = remove_comments_and_trim lines
    lines = remove_empty_lines lines

    current_section = Section.new("", "")
    lines.each do |line|
      if section_definition? line
        @sections << current_section unless current_section.queries.length == 0 && current_section.name == ''
        section_name, section_append = get_name_and_append_from_section_string line
        current_section = Section.new section_name, section_append
      else
        current_section.add_query line
      end
    end
    @sections << current_section unless current_section.queries.length == 0 && current_section.name == ''
  end

  private
  def section_definition?(s)
    section_word_index = s.index "$section"
    !section_word_index.nil?
  end

  def get_name_and_append_from_section_string(s)
    return get_attribute_value_from_section_string(s, 'name', true), get_attribute_value_from_section_string(s, 'append', false)
  end

  def get_attribute_value_from_section_string(s, attribute_name, required)
    attribute_index = s.index attribute_name
    if attribute_index.nil?
      if required
        raise FindpornException, "Section missing required attribute #{attribute_name}"
      else
        return ''
      end
    end
    first_quote_index = s.index '"', attribute_index
    second_quote_index = s.index '"', first_quote_index + 1
    if !first_quote_index.nil? && !second_quote_index.nil?
      return s[(first_quote_index+1)..(second_quote_index-1)]
    else
      raise FindpornException, "Incorrect definition for section.rb attribute #{attribute_name}"
    end
  end

  def remove_comments_and_trim(lines)
    lines.map do |line|
      comment_index = line.index '#'
      unless comment_index.nil?
        line[0...comment_index].strip
      else
        line.strip
      end
    end
  end

  def remove_empty_lines(lines)
    lines.select{|line| !line.nil? && !line.strip.empty?}
  end
end