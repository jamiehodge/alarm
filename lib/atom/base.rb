# encoding: UTF-8

module Atom
  class Base
    
    def initialize(xml)
      @doc = Nokogiri::XML(xml)
      ['title', 'author/name', 'author/email'].each do |e|
        self.class.send(:define_method, symbolize_method_name(e)) { text_at(e) }
      end
    end
    
    def id
      text_at('id').gsub(/urn:uuid:/, '')
    end
    
    def updated
      time_at('updated')
    end
    
    def link(type)
      @doc.at("#{self.class.name.split(':').last.downcase}/link[@rel=#{type}]")
    end

    def links(type)
      @doc.search("#{self.class.name.split(':').last.downcase}/link[@rel=#{type}]")
    end
    
    def path
      if catalog?
        "/catalogs/#{id}"
      else
        "/atom_feeds/#{id}"
      end
    end
    
    def self.with_uri(uri)
      self.new(open(URI.encode(uri))) rescue nil
    end
    
    private
    
      def text_at(args)
        @doc.at(args).inner_text rescue nil
      end
      
      def text_search(args)
        @doc.search(args).map(&:inner_text)
      end
      
      def time_at(args)
        Time.parse(text_at(args))
      end
      
      def symbolize_method_name(name)
        name.gsub(/[\/|]/, '_').to_sym
      end
  end
end