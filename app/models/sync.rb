class Sync
  def self.by_user
    @gcs = Calendar.users
    @tc = Timecrowd.new

    @gcs.each do |uid, gc|
      gc.api.events.each do |event|
        puts "delete #{event.title}"
        gc.api.delete_event(event)
      end
    end

    page = 1
    tes = @tc.time_entries(page)
    while tes.present? do
      tes.each do |te|
        begin
        uid   = te['user']['id']
        rescue
          raise te.inspect
        end
        next unless @gcs[uid]
        start_time = Time.at(te['started_at'])
        et = te['stopped_at']
        end_time = et ? Time.at(et) : Time.now
        title = te['task']['title'].gsub(/\n/, '')
        title = UNF::Normalizer.normalize(title, :nfkc)
        puts title
        @gcs[uid].api.create_event do |e|
          e.title      = title
          e.start_time = start_time
          e.end_time   = end_time
          e.description   = 'saved via https://github.com/pandeiro245/timecrowd2google_calendar'
        end
      end
      page += 1
      tes = @tc.time_entries(page)
    end
  end
end

