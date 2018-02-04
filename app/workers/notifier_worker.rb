class NotifierWorker
  include Sidekiq::Worker

  def perform
    Rails.logger.info 'Worker time...'
    Rails.logger.info DateTime.now.inspect
    user_count = User.count
    sight_count = Sighting.count
    fav_count = Favourite.count

    NotifierMailer.daily_stats_email(user_count, sight_count, fav_count).deliver
  rescue StandardError => e
    Rails.logger.info e.message
  end
end
