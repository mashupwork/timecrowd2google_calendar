class Gcal
  def initialize
    key = 'google_calendar_refresh_token'
    refresh_token = File.exist?("tmp/#{key}.txt") ? File.open("tmp/#{key}.txt", 'r').read : nil
    calendar = Calendar.first.calendar_id || 'primary'
    @gcal = Google::Calendar.new(:client_id    => ENV['GOOGLE_KEY'], 
                               :client_secret => ENV['GOOGLE_SECRET'],
                               :calendar      => calendar,
                               :redirect_url  => "urn:ietf:wg:oauth:2.0:oob"
                               )
    if !refresh_token or !@gcal.login_with_refresh_token(refresh_token)
      puts "Visit the following web page in your browser and approve access."
      puts @gcal.authorize_url
      puts "\nCopy the code that Google returned and paste it here:"
      refresh_token = @gcal.login_with_auth_code( $stdin.gets.chomp )

      puts "\nMake sure you SAVE YOUR REFRESH TOKEN so you don't have to prompt the user to approve access again."
      puts "your refresh token is:\n\t#{refresh_token}\n"
    end
    val = @gcal.refresh_token 
    File.open("tmp/#{key}.txt", 'w') { |file| file.write(val) }
  end

  def api
    @gcal
  end
end
