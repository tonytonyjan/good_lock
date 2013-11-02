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

  # Refresh access token, this can be used if user's access token was expired.
  # https://developers.google.com/accounts/docs/OAuth2WebServer#refresh
  def refresh_token!
    # Request Example:
    # POST /o/oauth2/token HTTP/1.1
    # Host: accounts.google.com
    # Content-Type: application/x-www-form-urlencoded
    # client_id=8819981768.apps.googleusercontent.com&
    # client_secret={client_secret}&
    # refresh_token=1/6BMfW9j53gdGImsiyUH5kU5RsR4zwI9lUVX-tqf8JXQ&
    # grant_type=refresh_token
    uri = URI('https://accounts.google.com/o/oauth2/token')
    params = {
      client_id: Settings.google.key,
      client_secret: Settings.google.secret,
      refresh_token: refresh_token,
      grant_type: :refresh_token
    }
    res = Net::HTTP.post_form(uri, params)
    body = JSON.parse(res.body)
    update! token: body['access_token']
    self
  end

  # https://developers.google.com/accounts/docs/OAuth2WebServer#callinganapi 
  # https://developers.google.com/apis-explorer
  def google_api params
    uri = URI(params[:url])
    data = params[:data] || {}
    method = params[:method] || :get

    req = nil
    case method
    when :get
      uri.query = URI.encode_www_form(data)
      req = Net::HTTP::Get.new(uri)
    when :post
      req = Net::HTTP::Post.new(uri)
      req.set_form_data data
    end
    req['Authorization'] = "Bearer #{token}"
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end
    body = JSON.parse(res.body)
  end

  # Get events from google calendar
  # Example:
  #
  #     user.get_events timeMax: DateTime.now.end_of_day.rfc3339, timeMin: DateTime.now.ago(1.day).beginning_of_day.rfc3339
  #
  def get_events params = {}
    google_api({url: "https://www.googleapis.com/calendar/v3/calendars/#{email}/events"}.merge!(data: params))
  end
end
