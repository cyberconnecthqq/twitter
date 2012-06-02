require 'twitter/identity_map'

module Twitter
  class Base
    attr_accessor :attrs
    alias :to_hash :attrs

    @@identity_map = IdentityMap.new

    # Define methods that retrieve the value from an initialized instance variable Hash, using the attribute as a key
    #
    # @overload self.lazy_attr_reader(attr)
    #   @param attr [Symbol]
    # @overload self.lazy_attr_reader(attrs)
    #   @param attrs [Array<Symbol>]
    def self.lazy_attr_reader(*attrs)
      attrs.each do |attribute|
        class_eval do
          define_method attribute do
            @attrs[attribute.to_s]
          end
        end
      end
    end

    def self.new(attrs={})
      @@identity_map[self.name] ||= {}
      @@identity_map[self.name][Marshal.dump(attrs)] || super(attrs)
    end

    # Initializes a new Base object
    #
    # @param attrs [Hash]
    # @return [Twitter::Base]
    def initialize(attrs={})
      @attrs = attrs
      @@identity_map[self.class.name][Marshal.dump(attrs)] = self
    end

    # Initializes a new Base object
    #
    # @param method [String, Symbol] Message to send to the object
    def [](method)
      self.__send__(method.to_sym)
    rescue NoMethodError
      nil
    end

  end
end
