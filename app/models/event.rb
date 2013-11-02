# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  event_id   :string(255)      not null
#  state      :string(255)      default("unset"), not null
#  created_at :datetime
#  updated_at :datetime
#

class Event < ActiveRecord::Base
  belongs_to :user
  extend Enumerize
  enumerize :state, in: %i(unset lock unlock)
  validates :user, :event_id, presence: true

  def to_param
    event_id
  end
end
