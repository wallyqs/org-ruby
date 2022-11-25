require_relative './highlighter.rb'

module Orgmode
  class HtmlOutputBuffer < OutputBuffer
    HtmlBlockTag = {
      :paragraph        => "p",
      :ordered_list     => "ol",
      :unordered_list   => "ul",
      :list_item        => "li",
      :definition_list  => "dl",
      :definition_term  => "dt",
      :definition_descr => "dd",
      :table            => "table",
      :table_row        => "tr",
      :quote            => "blockquote",
      :example          => "pre",
      :src              => "pre",
      :inline_example   => "pre",
      :center           => "div",
      :heading1         => "h1",
      :heading2         => "h2",
      :heading3         => "h3",
      :heading4         => "h4",
      :heading5         => "h5",
      :heading6         => "h6",
      :title            => "h1"
    }

    attr_reader :options

    def initialize(output, opts = {})
      super(output)
      @options = opts
      @new_paragraph = :start
      @footnotes = {}
      @unclosed_tags = []

      # move from output_buffer
      @code_block_indent = nil

      do_custom_markup
    end

    def buffer_tag
      'HTML'
    end

    # Output buffer is entering a new mode. Use this opportunity to
    # write out one of the block tags in the HtmlBlockTag constant to
    # put this information in the HTML stream.
    def push_mode(mode, indent, properties={})
      super(mode, indent, properties)
      return unless html_tags.include?(mode)
      return if skip_css?(mode)
      css_class = get_css_attr(mode)
      push_indentation(@new_paragraph != :start)

      html_tag = HtmlBlockTag[mode]
      # Check to see if we need to restart numbering from a
      # previous interrupted li
      if restart_numbering?(mode, properties)
        list_item_tag = HtmlBlockTag[:list_item]
        start = properties[list_item_tag]
        @output << "<#{html_tag} start=#{start}#{css_class}>"
      else
        @output << "<#{html_tag}#{css_class}>"
      end
      # Entering a new mode obliterates the title decoration
      @options[:decorate_title] = nil
    end

    def restart_numbering?(mode, properties)
      mode_is_ol?(mode) && properties.key?(HtmlBlockTag[:list_item])
    end

    def table?(mode)
      %i[table table_row table_separator table_header].include?(mode)
    end

    def src?(mode)
      %i[src].include?(mode)
    end

    def skip_syntax_highlight?
      !options[:skip_syntax_highlight]
    end

    def push_indentation(condition)
      indent = "  " * indentation_level
      condition && @output.concat("\n", indent)
      @new_paragraph = true
    end

    def html_tags
      HtmlBlockTag.keys
    end

    def skip_css?(mode)
      (table?(mode) && skip_tables?) ||
        (src?(mode) && skip_syntax_highlight?)
    end

    # We are leaving a mode. Close any tags that were opened when
    # entering this mode.
    def pop_mode(mode = nil)
      m = super(mode)
      return list_indent_stack.pop unless html_tags.include?(m)
      return list_indent_stack.pop if skip_css?(m)
      push_indentation(@new_paragraph)
      @output.concat("</#{HtmlBlockTag[m]}>")
      list_indent_stack.pop
    end

    def highlight(code, lang)
      Highlighter.highlight(code, lang)
    end

    def flush!
      return false if @buffer.empty?
      return @buffer = "" if (mode_is_table?(current_mode) && skip_tables?)

      if preserve_whitespace?
        strip_code_block! if mode_is_code? current_mode

        if (current_mode == :src)
          highlight_html_buffer
        else
          if (current_mode == :html || current_mode == :raw_text)
            remove_new_lines_in_buffer(@new_paragraph == :start)
          else
            @buffer = escapeHTML @buffer
          end
        end

        # Whitespace is significant in :code mode. Always output the
        # buffer and do not do any additional translation.
        @output << @buffer
      else
        @buffer.lstrip!
        @new_paragraph = nil
        if (current_mode == :definition_term)
          d = @buffer.split(/\A(.*[ \t]+|)::(|[ \t]+.*?)$/, 4)

          definition = d[1].strip
          if definition.empty?
            @output << "???"
          else
            @output << inline_formatting(definition)
          end
          indent = list_indent_stack.last
          pop_mode

          @new_paragraph = :start
          push_mode(:definition_descr, indent)
          @output.concat inline_formatting(d[2].strip + d[3])
          @new_paragraph = nil
        elsif (current_mode == :horizontal_rule)

          add_paragraph unless @new_paragraph == :start
          @new_paragraph = true
          @output << "<hr />"

        else
          @output << inline_formatting(@buffer)
        end
      end
      @buffer = ""
    end

    # Flush! helping methods
    def highlight_html_buffer
      if skip_syntax_hightlight?
        @buffer = escapeHTML @buffer
      else
        lang = normalize_lang @block_lang
        @buffer = highlight(@buffer, lang)
      end
    end

    def skip_syntax_hightlight?
      current_mode == :src && options[:skip_syntax_highlight]
    end

    def remove_new_lines_in_buffer(condition)
      return unless %i[html raw_text].include?(current_mode)

      condition && @buffer.gsub!(/\A\n/, "")
      @new_paragraph = true
    end
    #flush helpers ends here.


    def add_line_attributes(headline)
      if @options[:export_heading_number]
        level = headline.level
        headline_level = headline.headline_level
        heading_number = get_next_headline_number(headline_level)
        @output << "<span class=\"heading-number heading-number-#{level}\">#{heading_number}</span> "
      end
      if @options[:export_todo] and headline.keyword
        keyword = headline.keyword
        @output << "<span class=\"todo-keyword #{keyword}\">#{keyword}</span> "
      end
    end

    def html_buffer_code_block_indent(line)
      if mode_is_code?(current_mode) && !(line.block_type)
        # Determines the amount of whitespaces to be stripped at the
        # beginning of each line in code block.
        if line.paragraph_type != :blank
          if @code_block_indent
            @code_block_indent = [@code_block_indent, line.indent].min
          else
            @code_block_indent = line.indent
          end
        end
      end
    end


    # Only footnotes defined in the footnote (i.e., [fn:0:this is the footnote definition])
    # will be automatically
    # added to a separate Footnotes section at the end of the document. All footnotes that are
    # defined separately from their references will be rendered where they appear in the original
    # Org document.
    def output_footnotes!
      return false if !options[:export_footnotes] || @footnotes.empty?

      @output.concat footnotes_header
      @footnotes.each do |name, (defi, content)|
        @buffer = defi
        @output << "<div class=\"footdef\"><sup><a id=\"fn.#{name}\" href=\"#fnr.#{name}\">#{name}</a></sup>" \
                << "<p class=\"footpara\">" \
                << inline_formatting(@buffer) \
                << "</p></div>\n"
      end

      @output.concat "</div>\n</div>"

      true
    end

    def footnotes_header
      footnotes_title = options[:footnotes_title] || "Footnotes:"
      "\n<div id=\"footnotes\">\n<h2 class=\"footnotes\">#{footnotes_title}</h2>\n<div id=\"text-footnotes\">\n"
    end

    # Test if we're in an output mode in which whitespace is significant.
    def preserve_whitespace?
      super || current_mode == :html
    end

    protected

    def do_custom_markup
      file = options[:markup_file]
      return unless file
      return no_custom_markup_file_exists unless File.exists?(file)

      @custom_blocktags = load_custom_markup(file)
      @custom_blocktags.empty? && no_valid_markup_found ||
        set_custom_markup
    end

    def load_custom_markup(file)
      require 'yaml'
      if (self.class.to_s == 'Orgmode::MarkdownOutputBuffer')
        filter = '^MarkdownMap$'
      else
        filter = '^HtmlBlockTag$|^Tags$'
      end
      @custom_blocktags = YAML.load_file(@options[:markup_file]).select {|k| k.to_s.match(filter) }
    end



    ######################################################################
    private

    def get_css_attr(mode)
      case
      when (mode == :src and block_lang.empty?)
        " class=\"src\""
      when (mode == :src and not block_lang.empty?)
        " class=\"src\" lang=\"#{block_lang}\""
      when (mode == :example || mode == :inline_example)
        " class=\"example\""
      when mode == :center
        " style=\"text-align: center\""
      when @options[:decorate_title]
        " class=\"title\""
      when @options[:ltr]
        " dir=\"auto\""
      end
    end

    def skip_tables?
      options[:skip_tables]
    end

    def mode_is_table?(mode)
      (mode == :table or mode == :table_row or
       mode == :table_separator or mode == :table_header)
    end

    def mode_is_ol?(mode)
      mode == :ordered_list
    end

    # Escapes any HTML content in string
    def escape_string! str
      str.gsub!(/&/, "&amp;")
      # Escapes the left and right angular brackets but construction
      # @@html:<text>@@ which is formatted to <text>
      str.gsub! /<([^<>\n]*)/ do |match|
        ($`[-7..-1] == "@@html:" and $'[0..2] == ">@@") ? $& : "&lt;#{$1}"
      end
      str.gsub! /([^<>\n]*)>/ do |match|
        $`[-8..-1] == "@@html:<" ? $& : "#{$1}&gt;"
      end
      str.gsub! /@@html:(<[^<>\n]*>)@@/, "\\1"
    end

    def quote_tags(str)
      str.gsub /(<[^<>\n]*>)/, "@@html:\\1@@"
    end

    def buffer_indentation
       "  " * list_indent_stack.length
    end

    def add_paragraph
      indent = "  " * (list_indent_stack.length - 1)
      @output.concat "\n#{indent}"
    end

    Tags = {
      "*" => { :open => "b", :close => "b" },
      "/" => { :open => "i", :close => "i" },
      "_" => { :open => "span style=\"text-decoration:underline;\"",
        :close => "span" },
      "=" => { :open => "code", :close => "code" },
      "~" => { :open => "code", :close => "code" },
      "+" => { :open => "del", :close => "del" }
    }

    # Applies inline formatting rules to a string.
    def inline_formatting(str)
      @re_help.rewrite_emphasis(str) do |marker, text|
        if marker == "=" || marker == "~"
          escaped_text = escapeHTML(text)
          "<#{Tags[marker][:open]}>#{escaped_text}</#{Tags[marker][:close]}>"
        else
          quote_tags("<#{Tags[marker][:open]}>") + text +
            quote_tags("</#{Tags[marker][:close]}>")
        end
      end

      if @options[:use_sub_superscripts] then
        @re_help.rewrite_subp str do |type, text|
          if type == "_" then
            quote_tags("<sub>") + text + quote_tags("</sub>")
          elsif type == "^" then
            quote_tags("<sup>") + text + quote_tags("</sup>")
          end
        end
      end

      @re_help.rewrite_links str do |link, defi|
        [link, defi].compact.each do |text|
          # We don't support search links right now. Get rid of it.
          text.sub!(/\A(file:[^\s]+)::[^\s]*?\Z/, "\\1")
          text.sub!(/\Afile(|\+emacs|\+sys):(?=[^\s]+\Z)/, "")
        end

        # We don't add a description for images in links, because its
        # empty value forces the image to be inlined.
        defi ||= link unless link =~ @re_help.org_image_file_regexp

        if defi =~ @re_help.org_image_file_regexp
          defi = quote_tags "<img src=\"#{defi}\" alt=\"#{defi}\" />"
        end

        if defi
          link = @options[:link_abbrevs][link] if @options[:link_abbrevs].has_key? link
          quote_tags("<a href=\"#{link}\">") + defi + quote_tags("</a>")
        else
          quote_tags "<img src=\"#{link}\" alt=\"#{link}\" />"
        end
      end

      if @output_type == :table_row
        str.gsub! /^\|\s*/, quote_tags("<td>")
        str.gsub! /\s*\|$/, quote_tags("</td>")
        str.gsub! /\s*\|\s*/, quote_tags("</td><td>")
      end

      if @output_type == :table_header
        str.gsub! /^\|\s*/, quote_tags("<th>")
        str.gsub! /\s*\|$/, quote_tags("</th>")
        str.gsub! /\s*\|\s*/, quote_tags("</th><th>")
      end

      if @options[:export_footnotes] then
        @re_help.rewrite_footnote_definition str do |name, content|
          quote_tags("<sup><a id=\"fn.#{name}\" class=\"footnum\" href=\"#fnr.#{name}\">") +
            name + quote_tags("</a></sup> ") + content
        end

        @re_help.rewrite_footnote str do |name, defi|
          @footnotes[name] = defi if defi
          quote_tags("<sup><a id=\"fnr.#{name}\" class=\"footref\" href=\"#fn.#{name}\">") +
            name + quote_tags("</a></sup>")
        end
      end

      # Two backslashes \\ at the end of the line make a line break without breaking paragraph.
      if @output_type != :table_row and @output_type != :table_header then
        str.sub! /\\\\$/, quote_tags("<br />")
      end

      escape_string! str
      Orgmode.special_symbols_to_html str
      str = @re_help.restore_code_snippets str
    end

    def normalize_lang(lang)
      case lang
      when 'emacs-lisp', 'common-lisp', 'lisp'
        'scheme'
      when 'ipython'
        'python'
      when 'js2'
        'javascript'
      when ''
        'text'
      else
        lang
      end
    end

    # Helper method taken from Rails
    # https://github.com/rails/rails/blob/c2c8ef57d6f00d1c22743dc43746f95704d67a95/activesupport/lib/active_support/core_ext/kernel/reporting.rb#L10
    def silence_warnings
      warn_level = $VERBOSE
      $VERBOSE = nil
      yield
    ensure
      $VERBOSE = warn_level
    end

    def strip_code_block!
      if @code_block_indent and @code_block_indent > 0
        strip_regexp = Regexp.new("^" + " " * @code_block_indent)
        @buffer.gsub!(strip_regexp, "")
      end
      @code_block_indent = nil

      # Strip proctective commas generated by Org mode (C-c ')
      @buffer.gsub! /^(\s*)(,)(\s*)([*]|#\+)/ do |match|
        "#{$1}#{$3}#{$4}"
      end
    end

    private

    # The CGI::escapeHTML function backported from the Ruby standard library
    # as of commit fd2fc885b43283aa3d76820b2dfa9de19a77012f
    #
    # Implementation of the cgi module can change among Ruby versions
    # so stabilizing on a single one here to avoid surprises.
    #
    # https://github.com/ruby/ruby/blob/trunk/lib/cgi/util.rb
    #
    # The set of special characters and their escaped values
    TABLE_FOR_ESCAPE_HTML__ = {
      "'" => '&#39;',
      '&' => '&amp;',
      '"' => '&quot;',
      '<' => '&lt;',
      '>' => '&gt;'
    }.freeze

    # Escape special characters in HTML, namely &\"<>
    #   escapeHTML('Usage: foo "bar" <baz>')
    #      # => "Usage: foo &quot;bar&quot; &lt;baz&gt;"
    def escapeHTML(string)
      string.gsub(/['&"<>]/, TABLE_FOR_ESCAPE_HTML__)
    end
  end
end
