#
# Org to org exporter. Useful when wanting to modify 
# the parsed Org object dynamically and then export it back.
#
module Orgmode
  class OrgOutputBuffer < OutputBuffer
    def initialize(output, opts={});  super(output); end

    def flush!
      @output << @buffer
    end

    # Why is this called here instead on the parent class!?
    def output_footnotes!; super;  end;
  end
end
