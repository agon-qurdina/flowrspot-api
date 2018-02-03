class NotifierWorker
  include Sidekiq::Worker

  def perform
    begin
      users_count = User.count
      sighting_count = Sighting.count
      favourites_count = Favourite.count

      NotifierMailer.daily_stats_email(users_count, sighting_count, favourites_count).deliver

      Rails.logger.info 'workeeeer'
      Rails.logger.info DateTime.now.inspect
    rescue
      Rails.logger.info 'workeeeer error'
    end

  end
end
