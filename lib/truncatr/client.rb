require "twitter-text"

module Truncatr
  class Client
    include ::Twitter::Extractor

    attr_reader :original_message, :max_length, :modified_message

    def self.truncate(message, len=140)
      truncatr = new(message, len)
      truncatr.perform_truncation
      truncatr.modified_message
    end

    def initialize(message, len)
      @original_message = message
      @max_length = len
      @modifed_message = nil
    end

    def perform_truncation
      parts = break_apart_message
      @modified_message = truncate_parts(parts)
    end

    def break_apart_message
      parts = []
      results = extract_urls_with_indices(original_message)

      idx = 0
      results.each do |result|
        link = result[:url]
        start, finish = result[:indices]
        if start > idx
          msg = original_message[idx, start - idx]
          parts << Part.new('text', msg) if msg.length > 3
        end
        parts << Part.new('link', original_message[start, link.length])
        idx = finish
      end

      if idx < original_message.length
        parts << Part.new('text', original_message[idx..-1])
      end

      parts
    end

    def truncate_parts(parts)
      len = parts_length(parts)
      return parts_message(parts) if len <= max_length

      characters_over = len - max_length
      if parts.length == 1
        return parts.first.truncate(max_length)
      end

      # if last part starts after end of max length, drop last part
      p1 = parts[-1]
      p2 = parts[-2]

      return truncate_parts(parts[0..-2]) if parts_length(parts[0..-2]) > max_length
      return truncate_parts(parts[0..-2]) if p1.link? && p2.link?

      if p1.link?
        new_msg = [ parts_message(parts[0..-3]) ]
        remaining_chars = parts_length(parts[0..-3]) + p1.length + 1
        new_msg << p2.truncate(max_length - remaining_chars)
        new_msg << p1.text
        return new_msg.map(&:strip).join(" ").strip
      else
        return truncate(parts_message(parts), max_length)
      end
    end

    def parts_length(parts)
      spaces_between = parts.count - 1
      parts.map(&:length).inject(0, :+) + spaces_between
    end

    def parts_message(parts)
      parts.map(&:text).map(&:strip).join(" ").strip
    end

    def truncate(text, max_length)
      str = if (max_length - 3) < text.length
        "#{text[0, max_length - 3]}...".strip
      else
        text.strip
      end
    end
  end
end
