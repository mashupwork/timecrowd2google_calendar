class Sync
  def self.delete_all
    @cals = Calendar.users
    @cals.each do |uid, cal|
      puts "deletee timecrowd_user_id: #{uid}"
      events = cal.events
      return events # デバッグ中

      while events.present? do
        events.each do |event|
          puts "delete #{event.title}"
          cal.delete(event)
        end
        events = cal.gcal.api.events
        puts 'again'
      end
    end
  end

  def self.by_user
    @cals = Calendar.users
    @tc = Timecrowd.new

    page = 1
    tes = @tc.time_entries(page)
    while tes.present? do
      tes.each do |te|
        uid   = te['user']['id']
        next unless @cals[uid]
        start_time = Time.at(te['started_at'])
        et = te['stopped_at']
        end_time = et ? Time.at(et) : Time.now
        title = te['task']['title'].gsub(/\n/, '').gsub(/\t/, '')
        title = UNF::Normalizer.normalize(title, :nfkc)
        puts title
        @cals[uid].create({
          title: title,
          start_time: start_time,
          end_time: end_time,
          description: 'saved via https://github.com/pandeiro245/timecrowd2google_calendar'
        })
      end
      page += 1
      tes = @tc.time_entries(page)
    end
  end
end

