class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :require_login!, unless: :current_user
  before_action :set_event, only: %i(show update)
  authorize_resource

  def show
  end

  def update
    if @event.update(event_params)
      head :no_content
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find_or_create_by(user: current_user, event_id: params[:id])
  end

  def event_params
    params.require(:event).permit(:state)
  end
end
