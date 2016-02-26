class TimecrowdController < ApplicationController
  def login
    auth_hash = request.env['omniauth.auth']

    %w(expires_at refresh_token token).each do |key|
      val = auth_hash.credentials.send(key)
      File.open("tmp/timecrowd_#{key}.txt", 'w') { |file| file.write(val) }
    end

    redirect_to :root, notice: 'Signed in successfully'

  end
end

