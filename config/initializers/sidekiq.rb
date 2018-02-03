Rails.logger.info 'initializeeeer'
job = Sidekiq::Cron::Job.create(name: 'Notifier worker - every day', cron: "30 03 * * *", class: 'NotifierWorker')
Rails.logger.info job.inspect