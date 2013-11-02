class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:manage], Event, user_id: user.id
    end
  end
end
