class Gcal
  attr_accessor :api

  def initialize calendar_id
    key = 'google_calendar_refresh_token'
    refresh_token = self.class.get key
    @api = Google::Calendar.new(
      :client_id    => ENV['GOOGLE_KEY'], 
      :client_secret => ENV['GOOGLE_SECRET'],
      :calendar      => calendar_id,
      :redirect_url  => "urn:ietf:wg:oauth:2.0:oob"
    )
    if !refresh_token or !@api.login_with_refresh_token(refresh_token)
      puts "Visit the following web page in your browser and approve access."
      puts @api.authorize_url
      puts "\nCopy the code that Google returned and paste it here:"
      refresh_token = @api.login_with_auth_code( $stdin.gets.chomp )

      puts "\nMake sure you SAVE YOUR REFRESH TOKEN so you don't have to prompt the user to approve access again."
      puts "your refresh token is:\n\t#{refresh_token}\n"
    end
    val = @api.refresh_token 
    self.class.save key, val
  end

  def events
    api.events
  end

  def create params
    api.create_event do |e|
      e.title       = params[:title]
      e.start_time  = params[:start_time]
      e.end_time    = params[:end_time]
      e.description = params[:description]
    end
  end

  def delete event
    api.delete_event(event)
  end

  def self.get key
    path = "tmp/#{key}.txt"
    File.exist?(path) ? File.open(path, 'r').read : nil
  end

  def self.save key, val
    File.open("tmp/#{key}.txt", 'w') { |file| file.write(val) }
  end
end

