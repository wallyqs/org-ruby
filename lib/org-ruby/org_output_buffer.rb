#
# Org to org exporter. Useful when wanting to modify 
# the parsed Org object dynamically and then export it back.
#
module Orgmode
  class OrgOutputBuffer < OutputBuffer
    def initialize(output, opts={});  super(output); end

    def insert(line)
      case line
      when Orgmode::Headline
        @buffer << line.to_s << "\n"
        # Insert the PROPERTIES drawer in case there are some
        if not line.property_drawer.empty?
          @buffer << "  :PROPERTIES:\n"
          line.property_drawer.each do |key, value|
            @buffer << "  :#{key}:      #{value}\n"
          end
          @buffer << "  :END:\n"
        end
      when Orgmode::Line
        if line.property_drawer? or line.property_drawer_item?
          # Skip since these should have been recreated already
        else
          @buffer << line.to_s << "\n"
        end
      end
      flush!
      @buffer = ""
    end

    def flush!
      @output << @buffer
      @buffer = ""
    end

    # Why is this called here instead on the parent class!?
    def output_footnotes!; super;  end;
  end
end
