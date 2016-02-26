class Timecrowd
  VERSION = 'v1'
  attr_accessor :client, :access_token

  def initialize
    self.client = OAuth2::Client.new(
      ENV['TIMECROWD_CLIENT_ID'],
      ENV['TIMECROWD_SECRET_KEY'],
      site: 'https://timecrowd.net',
      ssl: { verify: false }
    )
    self.access_token = OAuth2::AccessToken.new(
      client,
      File.open("tmp/timecrowd_token.txt", 'r').read,
      refresh_token: File.open("tmp/timecrowd_refresh_token.txt", 'r').read,
      expires_at: File.open("tmp/timecrowd_expires_at.txt", 'r').read
    )

    #self.access_token = access_token.refresh! if self.access_token.expired?
    self.access_token = access_token.refresh!

    %w(expires_at refresh_token token).each do |key|
      val = self.access_token.send(key)
      File.open("tmp/timecrowd_#{key}.txt", 'w') { |file| file.write(val) }
    end
    access_token
  end

  def teams(state = nil)
    access_token.get("/api/#{VERSION}/teams?state=#{state}").parsed
  end

  def team(id)
    access_token.get("/api/#{VERSION}/teams/#{id}").parsed
  end

  def team_tasks(team_id, state = nil)
    access_token.get("/api/#{VERSION}/teams/#{team_id}/tasks?state=#{state}").parsed
  end

  def update_team_task(team_id, id, body)
    access_token.put("/api/#{VERSION}/teams/#{team_id}/tasks/#{id}", body: body).parsed
  end

  def working_users
    access_token.get("/api/#{VERSION}/user/working_users").parsed
  end

  def time_entries page = nil
    url = "/api/#{VERSION}/time_entries"
    url += "?page=#{page}" unless page.nil?
    puts url
    access_token.get(url).parsed
  end

  def create_time_entry(task)
    access_token.post(
      "/api/#{VERSION}/time_entries",
      body: {task: task}
    ).parsed
  end
end

