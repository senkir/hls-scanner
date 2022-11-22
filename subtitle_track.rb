class SubtitleTrack

  @uri
  attr_accessor :uri
  @language
  attr_accessor :language
  @default
  attr_accessor :default
  @name
  attr_accessor :name
  @default
  attr_accessor :default
  @group_id
  attr_accessor :group_id

  def self.parse entries

    track = SubtitleTrack.new
    key_values = HlsScanner::to_map entries
    key_values.each do | entry |
      key = entry[0] 
      value = entry[1] 
      puts "key #{key} with value = #{value}".green
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
      else
        puts "unknown key #{key}".red
      end
    end
    track
  end

  def log
    puts "SubtitleTrack : [ group-id:#{@group_id.light_blue} language=#{@language.red} name=#{@name.red} default=#{@default} ]"
  end
end