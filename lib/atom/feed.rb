module Atom
  class Feed < Atom::Base
    
    def initialize(xml)
      super(xml)
      ['subtitle', 'logo', 'icon', 'rights', 'generator'].each do |e|
        self.class.send(:define_method, symbolize_method_name(e)) { text_at(*e) }
      end
    end
    
    def generator_version
      @doc.at('generator')['version']
    end
    
    def generator_uri
      @doc.at('generator')['uri']
    end
    
    def entries
      @doc.search('entry').map { |e| Atom::Entry.new(e.to_s) }
    end
    
    def itunes_image
      @doc.at('itunes|image')['href'] unless catalog?
    end
    
    def formats
      text_search('pcp|entries/pcp|enclosedHints/pcp|format')
    end
    
    def catalog?
      !!( link('self')['feedtype'] =~ /catalog/ )
    end
    
    def root?
      !!( link('self')['feedtype'] =~ /root/ )
    end
    
    def subscribable?
      !(catalog?)
    end
    
  end
end