module Atom
  class Entry < Atom::Base
    
    def initialize(xml)
      super(xml)
      ['summary'].each do |e|
        self.class.send(:define_method, symbolize_method_name(e)) { text_at(*e) }
      end
    end
    
    def published
      time_at('published')
    end
    
    def keywords
      text_at('keywords').split(',').map(&:strip) if episode?
    end
    
    def comments
      Comment.filter(entry_id: id ).reverse_order(:created_at)
    end
    
    def catalog?
      !!( link('alternate') && link('alternate')['feedtype'] =~ /catalog/ )
    end
    
    def episode?
      !( link('alternate') )
    end
    
    def subscribable?
      !(catalog? || episode?)
    end
    
    def enclosures
      links('enclosure')
    end
    
    def video_enclosures
      enclosures.select { |link| link['hasVideo'] == 'yes'  }
    end
    
    def audio_enclosures
      enclosures.select { |link| link['hasVideo'] == 'no' && link['hasAudio'] == 'yes' }
    end
    
  end
end