#!/usr/bin/env ruby
#

require 'net/https'
require 'colorize'
require './hls_manifest.rb'
require './video_track.rb'
require './audio_track.rb'
require './subtitle_track.rb'


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
  

  @@hls_manifest
  
  
  def read_file url 
    response = Net::HTTP.get(URI.parse(url))

    @@hls_manifest = HlsManifest.new
    @@hls_manifest.video_url = url
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
    puts "parsing stream info... #{line}".colorize(:color => :light_blue)
        #TODO: parse stream info
        parse_stream_inf line
        #puts "stream info not implemented".red
      end
    end
      @@hls_manifest.log
  end

  def self.split entry
    entry.split('=',2)
  end

  def self.to_map line
    #sanitized line without prefix value
    # sanitized = line[prefix.length+1, line.length]

    entries = line.split(',',-1)

    map = {}
    entries.each do | entry |
      split = entry.split('=', 2)
      map[split[0]] = split[1]
    end
    map
  end

  def parse_stream_inf line
    parsed = line[STREAM_INFO_KEY.length+1, line.length]

    video = VideoTrack.parse(parsed)
    @@hls_manifest.video_tracks << video
  end

  #Process a line of the manifest as a media string
  def parse_media media
    puts "parsing media... #{media}".colorize(:color => :light_blue)
    #need to cut prefix off media entry

    parsed = media[MEDIA_KEY.length+1, media.length]

    #only care about the first key/value right now
    entries = parsed.split(',', -1)

    entry = entries[0]

    if entry == nil
      raise "unable to parse content. unrecognized format! #{entry} for #{parsed}".red
      exit
    end

    #determine type
    key_value = HlsScanner::to_map entry
    value = key_value["TYPE"]
    puts "type = #{value}"
    case value
    when "AUDIO"
      audio = AudioTrack.parse(parsed)
      @@hls_manifest.audio_tracks << audio
    when "SUBTITLES"
      subtitle = SubtitleTrack.parse(parsed)
      @@hls_manifest.subtitle_tracks << subtitle
    else
      puts "undetermined type #{value}".red
    end
  end
  
end

scanner = HlsScanner.new

scanner.read_file video_url
