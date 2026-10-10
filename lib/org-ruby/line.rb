module Orgmode

  # Represents a single line of an orgmode file.
  class Line

    # The indent level of this line. this is important to properly translate
    # nested lists from orgmode to textile.
    # TODO 2009-12-20 bdewey: Handle tabs
    attr_reader :indent

    # Backpointer to the parser that owns this line.
    attr_reader :parser

    # Paragraph type determined for the line.
    attr_reader :paragraph_type

    # Major modes associate paragraphs with a table, list and so on.
    attr_reader :major_mode

    # A line can have its type assigned instead of inferred from its
    # content. For example, something that parses as a "table" on its
    # own ("| one | two|\n") may just be a paragraph if it's inside
    # #+BEGIN_EXAMPLE. Set this property on the line to assign its
    # type. This will then affect the value of +paragraph_type+.
    attr_accessor :assigned_paragraph_type

    # In case more contextual info is needed we can put here
    attr_accessor :properties

    def initialize(line, parser=nil, assigned_paragraph_type=nil)
      @parser = parser
      @line = line
      @assigned_paragraph_type = assigned_paragraph_type
      @properties = { }
      # Memoizes the result of matching each regexp against the line so
      # that the many predicate methods below only pay for a regexp once.
      @match_cache = { }.compare_by_identity
      find_first_char
      @indent = blank? ? 0 : @line[/\A\s*/].length
      determine_paragraph_type
      determine_major_mode
      extract_properties
    end

    def to_s
      return @line
    end

    # Tests if a line is a comment.
    def comment?
      return @assigned_paragraph_type == :comment if @assigned_paragraph_type
      return block_type.casecmp("COMMENT") if begin_block? or end_block?
      return match(CommentRegexp)
    end

    CommentRegexp = /^[ \t]*?#[ \t]/

    PropertyDrawerRegexp = /^\s*:(PROPERTIES|END):/i

    def property_drawer_begin_block?
      m = match(PropertyDrawerRegexp)
      m && m[1] =~ /PROPERTIES/
    end

    def property_drawer_end_block?
      m = match(PropertyDrawerRegexp)
      m && m[1] =~ /END/
    end

    def property_drawer?
      check_assignment_or_regexp(:property_drawer, PropertyDrawerRegexp)
    end

    PropertyDrawerItemRegexp = /^\s*:([0-9A-Za-z_\-]+):\s*(.*)$/i

    def property_drawer_item?
      match(PropertyDrawerItemRegexp)
    end

    def property_drawer_item
      m = match(PropertyDrawerItemRegexp)
      m ? [m[1], m[2]] : [nil, nil]
    end

    # Tests if a line contains metadata instead of actual content.
    def metadata?
      check_assignment_or_regexp(:metadata, MetadataRegexp)
    end

    MetadataRegexp = /^\s*(CLOCK|DEADLINE|START|CLOSED|SCHEDULED):/

    def nonprinting?
      comment? || metadata? || begin_block? || end_block? || include_file?
    end

    def blank?
      check_assignment_or_regexp(:blank, BlankRegexp)
    end

    BlankRegexp = /^\s*$/

    def plain_list?
      ordered_list? or unordered_list? or definition_list?
    end

    UnorderedListRegexp = /^\s*(-|\+|\s+[*])\s+/

    def unordered_list?
      check_assignment_or_regexp(:unordered_list, UnorderedListRegexp)
    end

    def strip_unordered_list_tag
      @line.sub(UnorderedListRegexp, "")
    end

    DefinitionListRegexp = /^\s*(-|\+|\s+[*])\s+(.*\s+|)::($|\s+)/

    def definition_list?
      check_assignment_or_regexp(:definition_list, DefinitionListRegexp)
    end

    OrderedListRegexp = /^\s*\d+(\.|\))\s+/

    def ordered_list?
      check_assignment_or_regexp(:ordered_list, OrderedListRegexp)
    end

    ContinuedOrderedListRegexp = /^\[@(\d+)\]\s+/

    def strip_ordered_list_tag
      line = @line.sub(OrderedListRegexp, "")
      if line =~ ContinuedOrderedListRegexp
        line = line.sub(ContinuedOrderedListRegexp, "")
      end
      return line
    end

    # A checkbox at the start of a list item: [ ], [X], [x] or [-].
    CheckboxRegexp = /\A\[([ xX-])\](?:\s+|$)/

    # Checkbox state => the CSS class ox-html gives the list item.
    Checkboxes = { " " => "off", "X" => "on", "x" => "on", "-" => "trans" }

    def extract_properties
      if (ordered_list? or unordered_list?) and not definition_list?
        item_text = ordered_list? ? strip_ordered_list_tag : strip_unordered_list_tag
        if item_text =~ CheckboxRegexp
          @properties["checkbox"] = Checkboxes[$1]
        end
      end

      if match(OrderedListRegexp)
        line_without_number =  @line.sub(OrderedListRegexp, "")
        if line_without_number =~ ContinuedOrderedListRegexp
          # Extract the start of the ordered list and store it in
          # properties
          @properties["li"] = line_without_number.match(ContinuedOrderedListRegexp)[1]
        end
      end
    end

    HorizontalRuleRegexp = /^\s*-{5,}\s*$/

    def horizontal_rule?
      check_assignment_or_regexp(:horizontal_rule, HorizontalRuleRegexp)
    end

    # Extracts meaningful text and excludes org-mode markup,
    # like identifiers for lists or headings.
    def output_text
      return strip_checkbox(strip_ordered_list_tag) if ordered_list?
      return strip_checkbox(strip_unordered_list_tag) if unordered_list?
      return @line.sub(InlineExampleRegexp, "") if inline_example?
      return strip_raw_text_tag if raw_text?
      return @line
    end

    # Removes the checkbox from a list item's text; the exporters
    # render it themselves from properties["checkbox"].
    def strip_checkbox(text)
      @properties["checkbox"] ? text.sub(CheckboxRegexp, "") : text
    end

    def plain_text?
      not metadata? and not blank? and not plain_list?
    end

    TableRowRegexp = /^\s*\|/
    TableSeparatorRegexp = /^\s*\|[-\|\+]*\s*$/

    def table_row?
      # for an org-mode table, the first non-whitespace character is a
      # | (pipe).
      check_assignment_or_regexp(:table_row, TableRowRegexp)
    end

    def table_separator?
      # an org-mode table separator has the first non-whitespace
      # character as a | (pipe), then consists of nothing else other
      # than pipes, hyphens, and pluses.

      check_assignment_or_regexp(:table_separator, TableSeparatorRegexp)
    end

    # Checks if this line is a table header.
    def table_header?
      @assigned_paragraph_type == :table_header
    end

    def table?
      table_row? or table_separator? or table_header?
    end

    #
    # 1) block delimiters
    # 2) block type (src, example, html...) 
    # 3) switches (e.g. -n -r -l "asdf")
    # 4) header arguments (:hello world)
    #
    BlockRegexp = /^\s*#\+(BEGIN|END)_(\w*)\s*([0-9A-Za-z_\-]*)?\s*([^\":\n]*\"[^\"\n*]*\"[^\":\n]*|[^\":\n]*)?\s*([^\n]*)?/i

    def begin_block?
      m = match(BlockRegexp)
      m && m[1].casecmp?("BEGIN")
    end

    def end_block?
      m = match(BlockRegexp)
      m && m[1].casecmp?("END")
    end

    def block_type
      m = match(BlockRegexp)
      m[2] if m
    end

    def block_lang
      m = match(BlockRegexp)
      m[3] if m
    end

    def code_block?
      block_type =~ /^(EXAMPLE|SRC)$/i
    end

    # The block type as a symbol, with Org 9 export blocks mapped onto
    # the older backend-specific block types: "#+BEGIN_EXPORT html"
    # behaves like "#+BEGIN_HTML", and an export block for any other
    # backend is dropped like a comment block. "#+END_EXPORT" names no
    # backend, so it is treated as :html, which also closes the
    # comment mode in the parser.
    def effective_block_type
      type = block_type.downcase.to_sym
      return type unless type == :export
      (end_block? or block_lang.to_s.casecmp?("html")) ? :html : :comment
    end

    def block_switches
      m = match(BlockRegexp)
      m[4] if m
    end

    def block_header_arguments
      return @block_header_arguments if @block_header_arguments
      header_arguments = { }

      if (m = match(BlockRegexp))
        header_arguments_string = m[5]
        harray = header_arguments_string.split(' ')
        harray.each_with_index do |arg, i|
          next_argument = harray[i + 1]
          if arg =~ /^:/ and not (next_argument.nil? or next_argument =~ /^:/)
            header_arguments[arg] = next_argument
          end
        end
      end

      @block_header_arguments = header_arguments
    end

    # TODO: COMMENT block should be considered here
    def block_should_be_exported?
      export_state = block_header_arguments[':exports']
      case
      when ['both', 'code', nil, ''].include?(export_state)
        true
      when ['none', 'results'].include?(export_state)
        false
      end
    end

    def results_block_should_be_exported?
      export_state = block_header_arguments[':exports']
      case
      when ['results', 'both'].include?(export_state)
        true
      when ['code', 'none', nil, ''].include?(export_state)
        false
      end
    end

    InlineExampleRegexp = /^\s*:\s/

    # Test if the line matches the "inline example" case:
    # the first character on the line is a colon.
    def inline_example?
      check_assignment_or_regexp(:inline_example, InlineExampleRegexp)
    end

    RawTextRegexp = /^(\s*)#\+(\w+):\s*/

    # Checks if this line is raw text.
    def raw_text?
      check_assignment_or_regexp(:raw_text, RawTextRegexp)
    end

    def raw_text_tag
      m = match(RawTextRegexp)
      m[2].upcase if m
    end

    def strip_raw_text_tag
      @line.sub(RawTextRegexp) { |match| $1 }
    end

    InBufferSettingRegexp = /^#\+(\w+):\s*(.*)$/

    # call-seq:
    #     line.in_buffer_setting?         => boolean
    #     line.in_buffer_setting? { |key, value| ... }
    #
    # Called without a block, this method determines if the line
    # contains an in-buffer setting. Called with a block, the block
    # will get called if the line contains an in-buffer setting with
    # the key and value for the setting.
    def in_buffer_setting?
      return false if @assigned_paragraph_type && @assigned_paragraph_type != :comment
      m = match(InBufferSettingRegexp)
      if block_given? then
        yield m[1], m[2] if m
      else
        m
      end
    end

    # #+TITLE: is special because even though that it can be
    # written many times in the document, its value will be that of the last one
    def title?
      @assigned_paragraph_type == :title
    end

    ResultsBlockStartsRegexp = /^\s*#\+RESULTS:\s*(.+)?$/i

    def start_of_results_code_block?
      match(ResultsBlockStartsRegexp)
    end

    LinkAbbrevRegexp = /^\s*#\+LINK:\s*(\w+)\s+(.+)$/i

    def link_abbrev?
      match(LinkAbbrevRegexp)
    end

    def link_abbrev_data
      m = match(LinkAbbrevRegexp)
      [m[1], m[2]] if m
    end

    IncludeFileRegexp = /^\s*#\+INCLUDE:\s*"([^"]+)"(\s+([^\s]+)\s+(.*))?$/i

    def include_file?
      match(IncludeFileRegexp)
    end

    def include_file_path
      m = match(IncludeFileRegexp)
      File.expand_path m[1] if m
    end

    def include_file_options
      m = match(IncludeFileRegexp)
      [m[3], m[4]] if m and !m[2].nil?
    end

    # Determines the paragraph type of the current line.
    def determine_paragraph_type
      @paragraph_type = \
      case
      when blank?
        :blank
      when definition_list? # order is important! A definition_list is also an unordered_list!
        :definition_term
      when (ordered_list? or unordered_list?)
        :list_item
      when property_drawer_begin_block?
        :property_drawer_begin_block
      when property_drawer_end_block?
        :property_drawer_end_block
      when property_drawer_item?
        :property_drawer_item
      when metadata?
        :metadata
      when block_type
        if block_should_be_exported?
          case effective_block_type
          when :center, :comment, :example, :html, :quote, :src, :verse
            effective_block_type
          else
            :comment
          end
        else
          :comment
        end
      when title?
        :title
      when raw_text? # order is important! Raw text can be also a comment
        :raw_text
      when comment?
        :comment
      when table_separator?
        :table_separator
      when table_row?
        :table_row
      when table_header?
        :table_header
      when inline_example?
        :inline_example
      when horizontal_rule?
        :horizontal_rule
      else :paragraph
      end
    end

    def determine_major_mode
      @major_mode = \
      case
      when definition_list? # order is important! A definition_list is also an unordered_list!
        :definition_list
      when ordered_list?
        :ordered_list
      when unordered_list?
        :unordered_list
      when table?
        :table
      end
    end

    ######################################################################
    private

    # This function is an internal helper for determining the paragraph
    # type of a line... for instance, if the line is a comment or contains
    # metadata. It's used in routines like blank?, plain_list?, etc.
    #
    # What's tricky is lines can have assigned types, so you need to check
    # the assigned type, if present, or see if the characteristic regexp
    # for the paragraph type matches if not present.
    #
    # call-seq:
    #     check_assignment_or_regexp(assignment, regexp) => boolean
    #
    # assignment:: if the paragraph has an assigned type, it will be
    #              checked to see if it equals +assignment+.
    # regexp::     If the paragraph does not have an assigned type,
    #              the contents of the paragraph will be checked against
    #              this regexp.
    def check_assignment_or_regexp(assignment, regexp)
      return @assigned_paragraph_type == assignment if @assigned_paragraph_type
      return match(regexp)
    end

    # Matches +regexp+ against the line once and memoizes the
    # MatchData (or nil). The line text never changes after
    # construction, so the cache is always valid.
    #
    # Most of the regexps in this class can only match when the first
    # non-blank character of the line is one of a few characters (for
    # example a table row has to start with "|"). FirstCharFilter
    # records that, so for the common paragraph line we skip the
    # regexp entirely instead of running a dozen that cannot match.
    def match(regexp)
      return @match_cache[regexp] if @match_cache.key?(regexp)
      allowed = FirstCharFilter[regexp]
      if allowed and @first_char
        # "" in the table means the regexp only matches blank lines.
        possible = @first_char.empty? ? allowed.empty? : allowed.include?(@first_char)
        return @match_cache[regexp] = nil unless possible
      end
      @match_cache[regexp] = regexp.match(@line)
    end

    WhitespaceBytes = [0x20, 0x09, 0x0a, 0x0b, 0x0c, 0x0d] # same set as /\s/

    # Finds the first non-whitespace character of the line, "" when the
    # line is blank, or nil when the line contains an embedded newline
    # (then "^" could match in the middle and the filter is unsafe).
    def find_first_char
      newline = @line.index("\n")
      if newline and newline != @line.length - 1
        @first_char = nil
        return
      end
      i = 0
      i += 1 while WhitespaceBytes.include?(@line.getbyte(i))
      @first_char = @line[i] || ""
    end

    # Regexp => the characters that can start a matching line (after
    # leading whitespace). Regexps not listed here always run.
    FirstCharFilter = {
      BlankRegexp              => "",
      CommentRegexp            => "#",
      MetadataRegexp           => "CDS",
      PropertyDrawerRegexp     => ":",
      PropertyDrawerItemRegexp => ":",
      InlineExampleRegexp      => ":",
      UnorderedListRegexp      => "-+*",
      DefinitionListRegexp     => "-+*",
      OrderedListRegexp        => "0123456789",
      HorizontalRuleRegexp     => "-",
      TableRowRegexp           => "|",
      TableSeparatorRegexp     => "|",
      BlockRegexp              => "#",
      RawTextRegexp            => "#",
      InBufferSettingRegexp    => "#",
      ResultsBlockStartsRegexp => "#",
      LinkAbbrevRegexp         => "#",
      IncludeFileRegexp        => "#",
    }.compare_by_identity
  end                           # class Line
end                             # module Orgmode
