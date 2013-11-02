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
  def self.find_or_create_by_auth_hash auth_hash
    if user = User.find_by_uid(auth_hash[:uid]) || User.find_by_email(auth_hash[:info][:email])
      user.update(
        name: auth_hash[:info][:name] || user.name,
        image: auth_hash[:info][:image] || user.image,
        token: auth_hash[:credentials][:token] || user.token,
        refresh_token: auth_hash[:credentials][:refresh_token] || user.refresh_token,
        expires_at: auth_hash[:credentials][:expires_at] || user.expires_at,
        expires: auth_hash[:credentials][:expires] || user.expires
      )           
    else
      user = User.create(
        uid: auth_hash[:uid],
        email: auth_hash[:info][:email],
        name: auth_hash[:info][:name],
        image: auth_hash[:info][:image],
        token: auth_hash[:credentials][:token],
        refresh_token: auth_hash[:credentials][:refresh_token],
        expires_at: auth_hash[:credentials][:expires_at],
        expires: auth_hash[:credentials][:expires]
      )
    end
    user
  end
end
