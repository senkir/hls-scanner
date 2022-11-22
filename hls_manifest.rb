class HlsManifest

  @version
  attr_reader :version

  @video_url
  attr_reader :video_url
  attr_writer :video_url

  @audio_tracks
  attr_reader :audio_tracks

  @video_tracks
  attr_reader :video_tracks

  @subtitle_tacks
  attr_reader :subtitle_tracks

  def initialize
    @audio_tracks = []
    @video_tracks = []
    @subtitle_tracks = []
    @version = 0
    @video_url = ""
  end

  def log
    puts "################".green
    puts "HlsManifest content for url #{video_url}".green
    puts "################".green

    puts "Video Tracks #{log_video_content}"
    puts "################".green
    
    puts "Audio Tracks #{log_audio_content}"
    puts "################".green


    puts "Subtitle Tracks #{log_subtitle_content}"
    puts "################".green
  end

  def log_video_content
    #puts @video_tracks.to_s
    puts "array of video follows:".yellow
    @video_tracks.each do |track|
      puts track.log
    end
    puts "end array".yellow
  end

  def log_audio_content
    puts "array of audio follows:".yellow
    @audio_tracks.each do |track|
      puts track.log
    end
    puts "end array".yellow
  end

  def log_subtitle_content
    puts "array of subtitles follows:".yellow
    @subtitle_tracks.each do |track|
      puts track.log
    end
    puts "end array".yellow
  end
end