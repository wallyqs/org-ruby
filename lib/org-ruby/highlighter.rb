module Orgmode
  # Highlight code
  module Highlighter
    def self.highlight(code, lang)
      highlighter = guess_highlighter
      highlighter.highlight(code, lang)
    end

    def self.guess_highlighter
      return RougeHighliter if gem_present?('rouge')
      return PygmentsHighliter if gem_present?('pygments.rb')
      return CodeRayHighliter if gem_present?('coderay')

      DefaultHighliter
    end

    def self.gem_present?(gem)
      Gem::Specification.find_all_by_name(gem).any?
    end

    # Default highliter does nothing to code
    class DefaultHighliter
      def self.highlight(buffer, _lang)
        buffer
      end
    end

    # Pygments wrapper
    class PygmentsHighliter
      def self.highlight(buffer, lang)
        require 'pygments'
        if Pygments::Lexer.find_by_alias(lang)
          Pygments.highlight(buffer, lexer: lang)
        else
          Pygments.highlight(buffer, lexer: 'text')
        end
      end
    end

    # CodeRay wrapper
    class CodeRayHighliter
      def self.highlight(buffer, lang)
        require 'coderay'
        CodeRay.scan(buffer, lang).html(wrap: nil, css: :style)
      rescue ArgumentError => _e
        CodeRay.scan(buffer, 'text').html(wrap: nil, css: :style)
      end
    end

    # Rouge wrapper
    class RougeHighliter
      def self.highlight(buffer, lang)
        require 'rouge'
        formatter = Rouge::Formatters::HTMLLegacy.new
        lexer = Rouge::Lexer.find_fancy(lang, buffer) ||
                Rouge::Lexers::PlainText
        formatter.format(lexer.lex(buffer.strip))
      end
    end
  end
end
