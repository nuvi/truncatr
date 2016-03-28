module Truncatr
  class Part
    attr_accessor :type, :text

    def initialize(type, text)
      @type = type
      @text = text.strip
    end

    def link?
      type == 'link'
    end

    def truncate(max_length)
      return text.strip if link?
      str = if (max_length - 3) < text.length
        "#{text[0, max_length - 3]}...".strip
      else
        text.strip
      end
    end

    def truncate!(max_length)
      text = truncate(max_length)
    end

    def length
      return case type
        when 'link'
          23
        else
          text.length
      end
    end
  end
end
