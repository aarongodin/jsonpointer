require "json"

module JSONPointer
  class Accessor
    @source : String
    @subkeys : Array(String | Int32)

    def initialize(@source, @subkeys); end
  
    def get(input : JSON::Any) : JSON::Any
      @subkeys.reduce(input) do |value, subkey|
        value.dig(subkey)
      end
    end

    def get?(input : JSON::Any) : JSON::Any?
      self.get(input) rescue nil
    end

    def source
      @source
    end
  end

  def self.from(source : String)
    if source.size == 0
      return Accessor.new source, [] of String | Int32
    end

    subkeys = source.split('/')[1..].map do |key|
      if key =~ /^\d+$/ && !(key[0] == '0' && key.size > 1)
        key.to_i
      else
        String.build do |str|
          it = key.each_char
          curr = it.next

          while curr != Iterator::Stop::INSTANCE
            if curr == '~'
              # Starting escape sequence
              # Only allowed escape values are '0' and '1'
              case it.next
              when '0'
                str << '~'
              when '1'
                str << '/'
              else
                raise "Invalid JSON Pointer escape sequence"
              end
            else
              str << curr
            end

            curr = it.next
          end
        end
      end
    end

    Accessor.new source, subkeys
  end
end
