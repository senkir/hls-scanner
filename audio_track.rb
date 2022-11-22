class AudioTrack

  @language
  attr_accessor :language

  @name
  attr_accessor :name

  @default
  attr_accessor :default

  @autoselect
  attr_accessor :autoselect

  @group_id
  attr_accessor :group_id

  @uri
  attr_accessor :uri


  def self.parse entry

    track = AudioTrack.new

    key_values = HlsScanner::to_map entry

    puts "map generated #{key_values}"

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
      when "AUTOSELECT"
        track.autoselect = value
      end
    end
    track
  end

  def log
    puts "AudioTrack : [ group-id:#{@group_id.yellow} language=#{@language.red} name=#{@name.red} default=#{@default} autoselect=#{@autoselect} ]"
  end
end