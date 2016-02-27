class Calendar < ActiveRecord::Base
  attr_accessor :gcal

  def gcal
    @gcal ||= Gcal.new(calendar_id)
    @gcal
  end

  def self.users
    users = {}
    self.where.not(timecrowd_user_id: nil).each do |c|
      users[c.timecrowd_user_id] = c 
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

  def create params
    gcal.create params
  end
end

