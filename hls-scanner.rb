#!/usr/bin/env ruby
#
#
#
#
require 'net/https'

if (!ARGV || ARGV.size != 1) 
  puts "useage: ./hls-scanner.com/ [url]"
  exit
end
video_url = ARGV[0]

# TODO handle EXTM3U header
# TODO handle audio streams
# TODO handle video stream renditions
# TODO handle dubbing renditions
# TODO handle audio defaults
#
#


class HlsScanner

  HLS_HEADER = "#EXTM3U"
  HLS_VERSION_KEY = "#EXT-X-VERSION"
  MEDIA_KEY = "#EXT-X-MEDIA"
  STREAM_INFO_KEY = "#EXT-X-STREAM-INF"

  KEY_URI = "URI"

  MEDIA_TYPE_VIDEO = "VIDEO"
  MEDIA_YTPE_AUDIO = "AUDIO"
  MEDIA_TYPE_SUBTITLE = "SUBTITLES"

  class HlsManifest
    @version = 0
    @audio_tracks = []
    @video_tracks = []
    @subtitle_tacks = []

    attr_reader :audio_tracks
    attr_reader :video_tracks
    attr_reader :subtitle_tracks

    def log
      puts @audio_tracks
      puts @video_tracks
      puts @subtitle_tracks
    end
  end

  class VideoTrack
    @uri
    @group_id

    attr_reader :uri
    attr_reader :group_id

    def self.parse entry

      track = VideoTrack.new

      key_values = split entry

      key_values.each do | entry |
        key = entry[0] 
        value = entry[1] 
        case key
        when "URI"
          track.uri = value
        when "GROUP-ID"
          track.group_id = value
        end

      end

    end
  end

  class AudioTrack
    @language
    @name
    @default
    @autoselect
    @group_id
    @uri

    attr_reader :language
    attr_reader :name
    attr_reader :default
    attr_reader :autoselect
    attr_reader :uri
    attr_reader :group_id

    def self.parse entry

      track = AudioTrack.new

      key_values = HlsScanner::split entry

      key_values.each do | entry |
        key = entry[0] 
        value = entry[1] 
        case key
        when "URI"
          track.uri = value
        when "GROUP-ID"
          track.group_id = value
        when "LANGUAGE"
          track.language = value
        when "NAME"
          track.name = value
        when "DEFAULT"
          track.default = value
        when "AUTOSELECT"
          track.autoselect = value
        end

      end


    end
  end

  class StreamInfo
    @uri
    @bandwith
    @codecs
    @resolution
    @program_id

    attr_reader :uri
    attr_reader :bandwith
    attr_reader :codecs
    attr_reader :resolution
    attr_reader :program_id

    def self.parse entry

      key_values = split entry

      key_values.each do | entry |
        key = entry[0] 
        value = entry[1] 
        case key
        when "URI"
          track.uri = value
        when "BANDWIDTH"
          track.group_id = value
        when "CODECS"
          track.language = value
        when "RESOLUTION"
          track.name = value
        when "PROGRAM-ID"
          track.default = value
        end
      end
    end
  end

  class SubtitleTrack
    @language
    @default
    @name
    @autoselect

    attr_reader :language
    attr_reader :default
    attr_reader :name
    attr_reader :autoselect

    def self.parse entries

      track = SubtitleTrack.new

      key_values = split entry

      key_values.each do | entry |
        key = entry[0] 
        value = entry[1] 
        case key
        when "URI"
          track.uri = value
        when "GROUP-ID"
          track.group_id = value
        end

      end


    end
  end

  @@hls_manifest
  
  
  def read_file url 
    response = Net::HTTP.get(URI.parse(url))

    @@hls_manifest = HlsManifest.new
    parse_manifest response
  end

  def parse_manifest manifest 
    manifest.each_line do |line|
      if line.start_with? HLS_HEADER
        puts "header=#{line}"
      end
      if line.start_with? MEDIA_KEY
        parse_media line
      end
      if line.start_with? STREAM_INFO_KEY
        #TODO: parse stream info
        puts "stream info not implemented"
      end

      @@hls_manifest.log

    end
  end

  def self.split entry
    entry.split('=',2)
  end

  def parse_media media
    #need to cut prefix off media entry

    parsed = media[MEDIA_KEY.length+1, media.length]
    #puts "parsed = #{parsed}"

    entries = parsed.split(',', -1)
    entries.each do |entry|
      #determine type
      key_value = HlsScanner::split entry
      key = key_value[0]
      value = key_value[1]
      case key
      when "TYPE"
        puts "type! = #{value}"
        #split by type
        case value
        when "VIDEO"
          video = VideoTrack.parse(entry)
          @@hls_manifest.video_tracks << video

        when "AUDIO"
          audio = AudioTrack.parse(entry)
          @@hls_manifest.audio_tracks << audio
        when "SUBTITLE"
          subtitle = SubtitleTrack.parse(entry)
          @@hls_manifest.subtitle_tracks << subtitle
        else
          puts "undetermined type #{value}"
        end
        #end split by type
         # when "URI"
         #   puts "uri! = #{value}"
         # when "NAME"
         #   puts "name is #{value}"
         # when "DEFAULT"
         #   puts "is default is #{value}"
         # when "LANGUAGE"
         #   puts "language is #{value}"
         # when "GROUP-ID"
         #   puts "group is #{value}"
        else
          puts "unhandled key #{key}"
    end
  end

  end
end

scanner = HlsScanner.new

scanner.read_file video_url
