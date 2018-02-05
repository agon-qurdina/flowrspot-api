class NotifierMailer < ApplicationMailer
  def daily_stats_email(users_count, sightings_count, favourites_count)
    @user = AdminUser.first
    return if @user.blank?
    @users_count = users_count
    @sightings_count = sightings_count
    @favourites_count = favourites_count
    mail(to: @user.email, subject: 'Daily Stats')
  end
end
