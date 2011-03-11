require 'nokogiri'
require 'open-uri'

module Atom
	def initialize(doc)
		@doc = doc
	end
	
	def self.included(base)
		base.extend(ClassMethods)
	end
	
	module ClassMethods
		def with_uri(uri)
			self.parse(open(uri))
		end
		
		def parse(doc)
			self.new(Nokogiri::XML(doc))
		end
		
		def element(*args)
			args.each do |arg|
				self.send(:define_method, arg.gsub(/[\/|]/, '_')) { text_at(arg) }
			end
		end
		alias :elements :element
		
		def time_element(*args)
			args.each do |arg|
				self.send(:define_method, arg.gsub(/[\/|]/, '_')) { time_at(arg)}
			end
		end
		alias :time_elements :time_element
		
		def link(*args)
			args.each do |arg|
				self.send(:define_method, arg.gsub(/[\/|]/, '_') + '_link') { link_at(arg)}
			end
		end
		
		def links(*args)
			args.each do |arg|
				self.send(:define_method, arg.gsub(/[\/|]/, '_') + '_links') { link_search(arg)}
			end
		end
		
		def entries(arg)
			self.send(:define_method, 'entries') { @doc.search('entry').map { |e| eval("Atom::#{arg.capitalize}").new(e) } }
			self.send(:define_method, 'entry') { |uuid| @doc.search('entry').map { |e| eval("Atom::#{arg.capitalize}").new(e) }.find { |e| e.uuid == uuid }  }
		end
	end
	
	def uuid
		text_at('id').gsub(/urn:uuid:/, '') if text_at('id')
	end
	
	private
	
		def text_at(args)
			@doc.at(args).inner_text if @doc.at(args)
		end
		
		def text_search(args)
			@doc.search(args).map(&:inner_text) if @doc.search(args)
		end
		
		def time_at(args)
			Time.parse(text_at(args)) if text_at(args)
		end
		
		def link_at(arg)
			@doc.at "link[@rel=#{arg}]"
		end
		
		def link_search(arg)
			@doc.search "link[@rel=#{arg}]"
		end
end