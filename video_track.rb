class VideoTrack

  @bandwidth
  attr_accessor :bandwidth

  @codecs
  attr_accessor :codecs

  @resolution
  attr_accessor :resolution

  @audio
  attr_accessor :audio

  @subtitles
  attr_accessor :subtitles

  @program_id
  attr_accessor :program_id

  @closed_captions
  attr_accessor :closed_captions


  def self.parse entry

    track = VideoTrack.new
    key_values = HlsScanner::to_map entry
    key_values.each do | entry |
      key = entry[0] 
      value = entry[1] 
    puts "key #{key} with value = #{value}".green
      case key
      when "BANDWIDTH"
        track.bandwidth = value
      when "CODECS"
        track.codecs = value
      when "RESOLUTION"
        track.resolution = value
      when "AUDIO"
        track.audio = value
      when "SUBTITLES"
        track.subtitles = value
      when "CLOSED-CAPTIONS"
        track.closed_captions = value
      when "PROGRAM-ID"
        track.program_id = value
      else
        puts "unknown key #{key}".red
      end

    end
    track
  end


  def log
    puts "VideoTrack : [ bandwidth=#{@bandwidth} codecs=#{@codecs} resolution=#{resolution.red} audio=#{@audio.yellow} subtitles=#{subtitles.light_blue} program-id=#{@program_id} ]"
  end
end