class Admin::NotificationsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @notifications = RestockRequest.includes(:item, :customer).where(notified: true).order(updated_at: :desc)
  end

  def update
    notification = current_customer.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to admin_notifications_path
  end

end
