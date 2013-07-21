require 'rubypants'

module Orgmode

  ##
  ##  Simple routines for loading / saving an ORG file.
  ##

  class Parser

    # All of the lines of the orgmode file
    attr_reader :lines

    # All of the headlines in the org file
    attr_reader :headlines

    # These are any lines before the first headline
    attr_reader :header_lines

    # This contains any in-buffer settings from the org-mode file.
    # See http://orgmode.org/manual/In_002dbuffer-settings.html#In_002dbuffer-settings
    attr_reader :in_buffer_settings

    # This contains in-buffer options; a special case of in-buffer settings.
    attr_reader :options

    # Array of custom keywords.
    attr_reader :custom_keywords

    # Regexp that recognizes words in custom_keywords.
    def custom_keyword_regexp
      return nil if @custom_keywords.empty?
      Regexp.new("^(#{@custom_keywords.join('|')})\$")
    end

    # A set of tags that, if present on any headlines in the org-file, means
    # only those headings will get exported.
    def export_select_tags
      return Array.new unless @in_buffer_settings["EXPORT_SELECT_TAGS"]
      @in_buffer_settings["EXPORT_SELECT_TAGS"].split
    end

    # A set of tags that, if present on any headlines in the org-file, means
    # that subtree will not get exported.
    def export_exclude_tags
      return Array.new unless @in_buffer_settings["EXPORT_EXCLUDE_TAGS"]
      @in_buffer_settings["EXPORT_EXCLUDE_TAGS"].split
    end

    # Returns true if we are to export todo keywords on headings.
    def export_todo?
      "t" == @options["todo"]
    end

    # Returns true if we are to export footnotes
    def export_footnotes?
      "t" == @options["f"]
    end

    # Returns true if we are to export heading numbers.
    def export_heading_number?
      "t" == @options["num"]
    end

    # Should we skip exporting text before the first heading?
    def skip_header_lines?
      "t" == @options["skip"]
    end

    # Should we export tables? Defaults to true, must be overridden
    # with an explicit "nil"
    def export_tables?
      "nil" != @options["|"]
    end

    # Should we export sub/superscripts? (_{foo}/^{foo})
    # only {} mode is currently supported.
    def use_sub_superscripts?
      @options["^"] != "nil"
    end

    # I can construct a parser object either with an array of lines
    # or with a single string that I will split along \n boundaries.
    def initialize(lines, offset=0)
      if lines.is_a? Array then
        @lines = lines
      elsif lines.is_a? String then
        @lines = lines.split("\n")
      else
        raise "Unsupported type for +lines+: #{lines.class}"
      end

      @custom_keywords = []
      @headlines = Array.new
      @current_headline = nil
      @header_lines = []
      @in_buffer_settings = { }
      @options = { }
      mode = :normal
      previous_line = nil
      table_header_set = false
      @lines.each do |text|
        line = Line.new text, self
        mode = :normal if line.end_block? and mode == line.paragraph_type
        mode = :normal if line.property_drawer_end_block? and mode == :property_drawer

        case mode
        when :normal, :quote, :center
          if Headline.headline? line.to_s
            line = Headline.new line.to_s, self, offset
          elsif line.table_separator?
            if previous_line and previous_line.paragraph_type == :table_row and !table_header_set
              previous_line.assigned_paragraph_type = :table_header
              table_header_set = true
            end
          end
          table_header_set = false if !line.table?

        when :example, :html, :src
          # As long as we stay in code mode, force lines to be code.
          # Don't try to interpret structural items, like headings and tables.
          line.assigned_paragraph_type = :code
        end

        if mode == :normal
          @headlines << @current_headline = line if Headline.headline? line.to_s
          # If there is a setting on this line, remember it.
          line.in_buffer_setting? do |key, value|
            store_in_buffer_setting key.upcase, value
          end

          mode = line.paragraph_type if line.begin_block?
          mode = :property_drawer if previous_line and previous_line.property_drawer_begin_block?
        end

        if mode == :property_drawer and @current_headline
          @current_headline.property_drawer[line.property_drawer_item.first] = line.property_drawer_item.last
        end

        unless mode == :comment
          if @current_headline
            @current_headline.body_lines << line
          else
            @header_lines << line
          end
        end

        previous_line = line
      end                       # @lines.each
    end                         # initialize

    # Creates a new parser from the data in a given file
    def self.load(fname)
      lines = IO.readlines(fname)
      return self.new(lines)
    end

    # Saves the loaded orgmode file as a textile file.
    def to_textile
      output = ""
      output_buffer = TextileOutputBuffer.new(output)

      translate(@header_lines, output_buffer)
      @headlines.each do |headline|
        translate(headline.body_lines, output_buffer)
      end
      output
    end

    # Converts the loaded org-mode file to HTML.
    def to_html
      mark_trees_for_export
      export_options = {
        :decorate_title => @in_buffer_settings["TITLE"],
        :export_heading_number => export_heading_number?,
        :export_todo => export_todo?,
        :use_sub_superscripts =>  use_sub_superscripts?,
        :export_footnotes => export_footnotes?
      }
      export_options[:skip_tables] = true if not export_tables?
      output = ""
      output_buffer = HtmlOutputBuffer.new(output, export_options)

      if @in_buffer_settings["TITLE"] then

        # If we're given a new title, then just create a new line
        # for that title.
        title = Line.new(@in_buffer_settings["TITLE"], self)
        translate([title], output_buffer)
      end
      translate(@header_lines, output_buffer) unless skip_header_lines?

      # If we've output anything at all, remove the :decorate_title option.
      export_options.delete(:decorate_title) if (output.length > 0)
      @headlines.each do |headline|
        next if headline.export_state == :exclude
        case headline.export_state
        when :exclude
          # NOTHING
        when :headline_only
          translate(headline.body_lines[0, 1], output_buffer)
        when :all
          translate(headline.body_lines, output_buffer)
        end
      end
      output << "\n"

      rp = RubyPants.new(output)
      rp.to_html
    end

    def to_org
      mark_trees_for_export
      export_options = { :export_todo => export_todo? }
      output = ""
      output_buffer = OrgOutputBuffer.new(output, export_options)

      translate(@header_lines, output_buffer)
      @headlines.each do |headline|
        next if headline.export_state == :exclude
        case headline.export_state
        when :exclude
          # NOTHING
        when :headline_only
          translate(headline.body_lines[0, 1], output_buffer)
        when :all
          translate(headline.body_lines, output_buffer)
        end
      end
      output << "\n"

      output
    end

    ######################################################################
    private

    # Converts an array of lines to the appropriate format.
    # Writes the output to +output_buffer+.
    def translate(lines, output_buffer)
      output_buffer.output_type = :start
      lines.each { |line| output_buffer.insert(line) }
      output_buffer.flush!
      output_buffer.pop_mode while output_buffer.current_mode
      output_buffer.output_footnotes!
      output_buffer.output
    end

    # Uses export_select_tags and export_exclude_tags to determine
    # which parts of the org-file to export.
    def mark_trees_for_export
      marked_any = false
      # cache the tags
      select = export_select_tags
      exclude = export_exclude_tags
      inherit_export_level = nil
      ancestor_stack = []

      # First pass: See if any headlines are explicitly selected
      @headlines.each do |headline|
        ancestor_stack.pop while not ancestor_stack.empty? and headline.level <= ancestor_stack.last.level
        if inherit_export_level and headline.level > inherit_export_level
          headline.export_state = :all
        else
          inherit_export_level = nil
          headline.tags.each do |tag|
            if (select.include? tag) then
              marked_any = true
              headline.export_state = :all
              ancestor_stack.each { |a| a.export_state = :headline_only unless a.export_state == :all }
              inherit_export_level = headline.level
            end
          end
        end
        ancestor_stack.push headline
      end

      # If nothing was selected, then EVERYTHING is selected.
      @headlines.each { |h| h.export_state = :all } unless marked_any

      # Second pass. Look for things that should be excluded, and get rid of them.
      @headlines.each do |headline|
        if inherit_export_level and headline.level > inherit_export_level
          headline.export_state = :exclude
        else
          inherit_export_level = nil
          headline.tags.each do |tag|
            if (exclude.include? tag) then
              headline.export_state = :exclude
              inherit_export_level = headline.level
            end
          end
          if headline.comment_headline?
            headline.export_state = :exclude
            inherit_export_level = headline.level
          end
        end
      end
    end

    # Stores an in-buffer setting.
    def store_in_buffer_setting(key, value)
      if key == "OPTIONS" then

        # Options are stored in a hash. Special-case.

        value.split.each do |opt|
          if opt =~ /^(.*):(.*?)$/ then
            @options[$1] = $2
          else
            raise "Unexpected option: #{opt}"
          end
        end
      elsif key =~ /^(TODO|SEQ_TODO|TYP_TODO)$/ then
        # Handle todo keywords specially.
        value.split.each do |keyword|
          keyword.gsub!(/\(.*\)/, "") # Get rid of any parenthetical notes
          keyword = Regexp.escape(keyword)
          next if keyword == "\\|"      # Special character in the todo format, not really a keyword
          @custom_keywords << keyword
        end
      else
        @in_buffer_settings[key] = value
      end
    end
  end                             # class Parser
end                               # module Orgmode
