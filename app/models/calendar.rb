class Calendar < ActiveRecord::Base
  def self.users
    users = {}
    self.where.not(timecrowd_user_id: nil).each do |c|
      users[c.timecrowd_user_id] = Gcal.new(c.calendar_id)
    end
    users
  end

  def self.add calendar_id, timecrowd_user_id, title
    calendar = self.find_or_create_by(
      calendar_id: calendar_id, 
    )
    calendar.timecrowd_user_id = timecrowd_user_id
    calendar.title =  title
    calendar.save
  end
end

