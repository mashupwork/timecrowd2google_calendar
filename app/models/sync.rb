class Sync
  def self.do
    @gc = Gcal.new
    @tc = Timecrowd.new

    @gc.api.events.each do |event|
      puts "delete #{event.title}"
      @gc.api.delete_event(event)
    end

    @tc.my_time_entries.each do |te|
      start_time = Time.at(te['started_at'])
      et = te['stopped_at']
      end_time = et ? Time.at(et) : Time.now
      title = te['task']['title'].gsub(/\n/, '')
      puts title
      @gc.api.create_event do |e|
        e.title      = title
        e.start_time = start_time
        e.end_time   = end_time
        e.description   = 'saved via https://github.com/pandeiro245/timecrowd2google_calendar'
      end
    end
  end
end

