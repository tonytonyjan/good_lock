# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  uid           :string(255)
#  name          :string(255)
#  email         :string(255)
#  image         :string(255)
#  token         :text
#  refresh_token :text
#  expires_at    :integer
#  expires       :boolean
#  created_at    :datetime
#  updated_at    :datetime
#

class User < ActiveRecord::Base
end
