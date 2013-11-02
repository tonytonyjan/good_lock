class Event < ActiveRecord::Base
  belongs_to :user
  extend Enumerize
  enumerize :state, in: %i(unset lock unlock)
  validates :user, :event_id, presence: true

  def to_param
    event_id
  end
end
