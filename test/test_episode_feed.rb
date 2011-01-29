require 'test/unit'
require 'test_unit_extensions'
require 'open-uri'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'atom'

class TestEpisodeFeed < Test::Unit::TestCase
  
  def setup
    builder = Nokogiri::XML::Builder.new do
      feed xmlns: 'http://www.w3.org/2005/Atom', :'xmlns:itunes' => 'http://www.itunes.com/dtds/podcast-1.0.dtd', :'xmlns:pcp' => "http://www.apple.com/dtds/pcp-1.0.dtd", :'xml:lang' => 'English' do
        title 'User Name', type: 'text'
        subtitle 'Episodes submitted by this user.', type: 'text'
        author do
          email 'user@example.com'
          name  'User Name'
        end
        updated '2010-12-15T15:03:30+01:00'
        id_      'urn:uuid:E70D82E2-08B0-4A50-9E02-8547D8135F13'
        logo    'http://example.com/podcastproducer/feed_logos/E70D82E2-08B0-4A50-9E02-8547D8135F13.png'
        self['itunes'].image href: 'http://example.com/podcastproducer/feed_logos/E70D82E2-08B0-4A50-9E02-8547D8135F13.png'
        icon    'http://example.com/podcastproducer/feed_icons/E70D82E2-08B0-4A50-9E02-8547D8135F13.png'
        rights  'Rights Owner'
        generator 'Podcast Producer', version: '2.1', uri: 'http://www.apple.com/server/macosx/features/podcasts.html'
        link type: 'application/atom+xml', title: 'User Name', href: 'http://example.com/podcastproducer/atom_feeds/E70D82E2-08B0-4A50-9E02-8547D8135F13', :'pcp:feedtype' => 'user', rel: 'self'
        link type: 'text/html', title: 'Podcast Producer', href: 'http://example.com/podcastproducer/', rel: 'alternate'
        self['itunes'].explicit 'no'
        link type: 'application/atom+xml', title: 'Podcast Library', href: 'http://example.com/podcastproducer/catalogs', :'pcp:feedtype' => 'root_catalog', rel: 'root'
        entry do
          title 'Interview with Someone', type: 'text'
          summary 'Summary', type: 'text'
          author do
            name 'Author Name'
          end
          published '2010-12-15T15:03:30+01:00'
          updated   '2010-12-15T15:07:39+01:00'
          id        'urn:uuid:B5DD3379-26BF-48F4-8961-B346D8CB16FF'
          self['itunes'].explicit 'no'
          self['itunes'].keywords 'this, that, other'
          link type: 'audio/x-m4a', href: 'http://example.com/podcastproducer/attachments/E70D82E2-08B0-4A50-9E02-8547D8135F13/96F58AD2-58F1-4C6E-B30C-490181E448DF.m4a', title: 'Audio', :'pcp:format' => 'com.apple.audio', :'pcp:isStreaming' => 'no', length: '5864394', :'pcp:duration' => '00:05:45', :'pcp:audioDataRate' => '133.74', :'pcp:hasAudio' => 'yes', :'pcp:audioChannels' => '2', :'pcp:hasVideo' => 'no', :'pcp:audioCodec' => 'AAC', :'pcp:hasChapters' => 'no', rel: 'enclosure', :'pcp:hasClosedCaptions' => 'no'
          link type: 'image/png', href: 'http://example.com/podcastproducer/attachments/E70D82E2-08B0-4A50-9E02-8547D8135F13/58D8FA25-F11C-4171-8CAB-96550C5566A0.png', title: 'Poster Image', :'pcp:format' => 'com.apple.document', :'pcp:width' => '640', length: '74314', :'pcp:height' => '480', :'pcp:role' => 'image', rel: 'related'
        end
        self['pcp'].entries hasMultipleEnclosures: 'no' do
          self['pcp'].enclosedHints do
            self['pcp'].format 'com.apple.audio'
          end
        end
      end
    end

    @feed = Atom::Feed.new(builder.to_xml)
  end
  
  must 'parse title' do
    assert_equal 'User Name', @feed.title
  end
  
  must 'parse subtitle' do
    assert_equal 'Episodes submitted by this user.', @feed.subtitle
  end
  
  must 'parse id' do
    assert_equal 'E70D82E2-08B0-4A50-9E02-8547D8135F13', @feed.id
  end
  
  must 'parse logo' do
    assert_equal 'http://example.com/podcastproducer/feed_logos/E70D82E2-08B0-4A50-9E02-8547D8135F13.png', @feed.logo
  end
  
  must 'parse icon' do
    assert_equal 'http://example.com/podcastproducer/feed_icons/E70D82E2-08B0-4A50-9E02-8547D8135F13.png', @feed.icon
  end
  
  must 'parse itunes:image' do
    assert_equal 'http://example.com/podcastproducer/feed_logos/E70D82E2-08B0-4A50-9E02-8547D8135F13.png', @feed.itunes_image
  end
  
  must 'parse itunes:explicit' do
    assert_equal 'no', @feed.itunes_explicit
  end
  
  must 'parse rights' do
    assert_equal 'Rights Owner', @feed.rights
  end
  
  must 'parse author' do
    assert_equal 'user@example.com', @feed.author_email
    assert_equal 'User Name', @feed.author_name
  end
  
  must 'parse generator' do
    assert_equal 'Podcast Producer', @feed.generator
    assert_equal '2.1', @feed.generator_version
    assert_equal 'http://www.apple.com/server/macosx/features/podcasts.html', @feed.generator_uri
  end
  
  must 'parse updated' do
    assert_equal Time.parse('2010-12-15T15:03:30+01:00'), @feed.updated
  end
  
  must 'parse link rel=self' do
    assert_equal 'application/atom+xml', @feed.link('self')['type']
    assert_equal 'User Name', @feed.link('self')['title']
    assert_equal 'http://example.com/podcastproducer/atom_feeds/E70D82E2-08B0-4A50-9E02-8547D8135F13', @feed.link('self')['href']
    assert_equal 'user', @feed.link('self')['feedtype']
    assert_equal 'self', @feed.link('self')['rel']
  end
  
  must 'parse link rel=root' do
    assert_equal 'application/atom+xml', @feed.link('root')['type']
    assert_equal 'Podcast Library', @feed.link('root')['title']
    assert_equal 'http://example.com/podcastproducer/catalogs', @feed.link('root')['href']
    assert_equal 'root_catalog', @feed.link('root')['feedtype']
    assert_equal 'root', @feed.link('root')['rel']
  end
  
  must 'parse link rel=alternate' do
    assert_equal 'text/html', @feed.link('alternate')['type']
    assert_equal 'Podcast Producer', @feed.link('alternate')['title']
    assert_equal 'http://example.com/podcastproducer/', @feed.link('alternate')['href']
    assert_equal 'alternate', @feed.link('alternate')['rel']
  end
  
  must 'parse entries title' do
    @entry = @feed.entries.first
    assert_equal 'Interview with Someone', @entry.title
  end
  
  must 'parse entries summary' do
    @entry = @feed.entries.first
    assert_equal 'Summary', @entry.summary
  end
  
  must 'parse entries id' do
    @entry = @feed.entries.first
    assert_equal 'B5DD3379-26BF-48F4-8961-B346D8CB16FF', @entry.id
  end
  
  must 'parse entries author' do
    @entry = @feed.entries.first
    assert_equal nil, @entry.author_email
    assert_equal 'Author Name', @entry.author_name
  end
  
  must 'parse entries itunes:keywords' do
    @entry = @feed.entries.first
    assert_equal %w{this that other}, @entry.keywords
  end
  
  must 'parse entries itunes:explicit' do
    @entry = @feed.entries.first
    assert_equal 'no', @entry.itunes_explicit
  end
  
  must 'parse entries rel=related' do
    @entry = @feed.entries.first
    @related = @entry.link('related')
    assert_equal 'image/png', @related['type']
    assert_equal 'http://example.com/podcastproducer/attachments/E70D82E2-08B0-4A50-9E02-8547D8135F13/58D8FA25-F11C-4171-8CAB-96550C5566A0.png', @related['href']
    assert_equal 'Poster Image', @related['title']
    assert_equal 'com.apple.document', @related['format']
    assert_equal '640', @related['width']
    assert_equal '480', @related['height']
    assert_equal '74314', @related['length']
    assert_equal 'image', @related['role']
    assert_equal 'related', @related['rel']
  end
  
  must 'parse entries rel=enclosure' do
    @entry = @feed.entries.first
    @enclosure = @entry.links('enclosure').first
    assert_equal 'audio/x-m4a', @enclosure['type']
    assert_equal 'http://example.com/podcastproducer/attachments/E70D82E2-08B0-4A50-9E02-8547D8135F13/96F58AD2-58F1-4C6E-B30C-490181E448DF.m4a', @enclosure['href']
    assert_equal 'Audio', @enclosure['title']
    assert_equal 'com.apple.audio', @enclosure['format']
    assert_equal 'no', @enclosure['isStreaming']
    assert_equal '5864394', @enclosure['length']
    assert_equal '00:05:45', @enclosure['duration']
    assert_equal '133.74', @enclosure['audioDataRate']
    assert_equal 'yes', @enclosure['hasAudio']
    assert_equal '2', @enclosure['audioChannels']
    assert_equal 'no', @enclosure['hasVideo']
    assert_equal 'AAC', @enclosure['audioCodec']
    assert_equal 'no', @enclosure['hasChapters']
    assert_equal 'no', @enclosure['hasClosedCaptions']
    assert_equal 'enclosure', @enclosure['rel']
  end
  
  must 'parse entries published' do
    @entry = @feed.entries.first
    assert_equal Time.parse('2010-12-15 15:03:30 +0100'), @entry.published
  end
  
  must 'parse entries updated' do
    @entry = @feed.entries.first
    assert_equal Time.parse('2010-12-15T15:07:39+01:00'), @entry.updated
  end
  
  must 'parse enclosed format hints' do
    assert_equal 'com.apple.audio', @feed.formats.first
  end
end