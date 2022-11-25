require 'logger'

module Orgmode

  # = Summary
  #
  # This class contains helper routines to deal with the Regexp "black
  # magic" you need to properly parse org-mode files.
  #
  # = Key methods
  #
  # * Use +rewrite_emphasis+ to replace org-mode emphasis strings (e.g.,
  #   \/italic/) with the suitable markup for the output.
  #
  # * Use +rewrite_links+ to get a chance to rewrite all org-mode
  #   links with suitable markup for the output.
  #
  # * Use +rewrite_images+ to rewrite all inline image links with suitable
  #   markup for the output.
  class RegexpHelper

    ######################################################################
    # EMPHASIS
    #
    # I figure it's best to stick as closely to the elisp implementation
    # as possible for emphasis. org.el defines the regular expression that
    # is used to apply "emphasis" (in my terminology, inline formatting
    # instead of block formatting). Here's the documentation from org.el.
    #
    # Terminology: In an emphasis string like " *strong word* ", we
    # call the initial space PREMATCH, the final space POSTMATCH, the
    # stars MARKERS, "s" and "d" are BORDER characters and "trong wor"
    # is the body.  The different components in this variable specify
    # what is allowed/forbidden in each part:
    #
    # pre          Chars allowed as prematch.  Line beginning allowed, too.
    # post         Chars allowed as postmatch.  Line end will be allowed too.
    # border       The chars *forbidden* as border characters.
    # body-regexp  A regexp like \".\" to match a body character.  Don't use
    #              non-shy groups here, and don't allow newline here.
    # newline      The maximum number of newlines allowed in an emphasis exp.

    def initialize
      # Set up the emphasis regular expression.
      @code_snippet_stack = []
      @logger = Logger.new(STDERR)
      @logger.level = Logger::WARN
    end

    # Finds all emphasis matches in a string.
    # Supply a block that will get the marker and body as parameters.
    def match_all(str)
      str.scan(org_emphasis_regexp) do |_match|
        yield Regexp.last_match[2], Regexp.last_match[3]
      end
    end

    # Compute replacements for all matching emphasized phrases.
    # Supply a block that will get the marker and body as parameters;
    # return the replacement string from your block.
    #
    # = Example
    #
    #   re = RegexpHelper.new
    #   result = re.rewrite_emphasis("*bold*, /italic/, =code=") do |marker, body|
    #       "<#{map[marker]}>#{body}</#{map[marker]}>"
    #   end
    #
    # In this example, the block body will get called three times:
    #
    # 1. Marker: "*", body: "bold"
    # 2. Marker: "/", body: "italic"
    # 3. Marker: "=", body: "code"
    #
    # The return from this block is a string that will be used to
    # replace "*bold*", "/italic/", and "=code=",
    # respectively. (Clearly this sample string will use HTML-like
    # syntax, assuming +map+ is defined appropriately.)
    def rewrite_emphasis(str)
      # escape the percent signs for safe restoring code snippets
      str.gsub!(/%/, "%%")
      format_str = "%s"
      str.gsub!(org_emphasis_regexp) do |_match|
        pre = Regexp.last_match(1)
        # preserve the code snippet from further formatting
        inner = yield Regexp.last_match(2), Regexp.last_match(3)
        if %w[= ~].include?(Regexp.last_match(2))
          # code is not formatted, so turn to single percent signs
          inner.gsub!(/%%/, "%")
          @code_snippet_stack.push inner
          "#{pre}#{format_str}"
        else
          "#{pre}#{inner}"
        end
      end
    end

    # rewrite subscript and superscript (_{foo} and ^{bar})
    def rewrite_subp(str)
      str.gsub!(org_subp_regexp) do |_match|
        yield Regexp.last_match(1), Regexp.last_match(2)
      end
    end

    # rewrite footnotes
    def rewrite_footnote(str)
      str.gsub!(org_footnote_regexp) do |_match|
        yield Regexp.last_match(1), Regexp.last_match(3)
      end
    end

    def rewrite_footnote_definition(str)
      str.gsub!(org_footnote_def_regexp) do |_match|
        yield Regexp.last_match(1), Regexp.last_match(5)
      end
    end

    # = Summary
    #
    # Rewrite org-mode links in a string to markup suitable to the
    # output format.
    #
    # = Usage
    #
    # Give this a block that expect the link and optional friendly
    # text. Return how that link should get formatted.
    #
    # = Example
    #
    #   re = RegexpHelper.new
    #   result = re.rewrite_links("[[http://www.bing.com]] and [[http://www.hotmail.com][Hotmail]]") do |link, text}
    #       text ||= link
    #       "<a href=\"#{link}\">#{text}</a>"
    #    end
    #
    # In this example, the block body will get called two times. In the
    # first instance, +text+ will be nil (the org-mode markup gives no
    # friendly text for the link +http://www.bing.com+. In the second
    # instance, the block will get text of *Hotmail* and the link
    # +http://www.hotmail.com+. In both cases, the block returns an
    # HTML-style link, and that is how things will get recorded in
    # +result+.
    def rewrite_links(str)
      str.gsub!(org_link_regexp) do |_match|
        yield Regexp.last_match['url'], Regexp.last_match['friendly_text']
      end
      str.gsub!(org_angle_link_text_regexp) do |_match|
        yield Regexp.last_match(1), nil
      end

      str # for testing
    end

    def restore_code_snippets(str)
      str = str % @code_snippet_stack
      @code_snippet_stack = []
      str
    end

    def org_emphasis_regexp
      Regexp.new("(#{pre_emphasis_regexp})" \
                 "(#{markers_regexp})" \
                 "(#{border_forbidden}|" \
                 "#{border_forbidden}#{body_regexp}" \
                 "#{border_forbidden})\\2" \
                 "(?=#{post_emphasis})")
    end

    def org_link_regexp
      /\[\[(?<url>[^\[\]]+)\](\[(?<friendly_text>[^\[\]]+)\])?\]/x
    end

    def org_image_file_regexp
      /\.(gif|jpe?g|p(?:bm|gm|n[gm]|pm)|svgz?|tiff?|x[bp]m)/i
    end

    private

    def pre_emphasis_regexp
      '^|\s|[\(\'"\{\[]'
    end

    def markers_regexp
      '[\*\/_=~\+]'
    end

    def border_forbidden
      '\S'
    end

    def post_emphasis
      '\s|[-,\.;:!\?\'"\)\}\]]|$'
    end

    def body_regexp
      '.*?(?:\\n.*?){0,1}'
    end

    def org_subp_regexp
      /([_^])\{(.*?)\}/
    end

    def org_footnote_regexp
      /\[fn:(.+?)(:(.*))?\]/
    end

    def org_footnote_def_regexp
      /^\[fn:(.+?)(:(.*))?\]( (.+))?/
    end

    def org_angle_link_text_regexp
      /<(\w+:[^\]\s<>]+)>/
    end
  end
end
