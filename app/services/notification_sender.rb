class NotificationSender
  attr_reader :message, :user_device_ids

  # Firebase has a limit of 1000 users per call
  CHUNK_SIZE = 1000

  def initialize(user_device_ids, message)
    user_device_ids = Array(user_device_ids) unless user_device_ids.is_a?(Array)
    @user_device_ids = user_device_ids
    @message = message
  end

  def call
    return if user_device_ids.empty?
    user_device_ids.each_slice(CHUNK_SIZE) do |device_ids|
      fcm_client.send(device_ids, options)
    end
  end

  private

  def options
    {
        data: {
            message: message
        }
    }
  end

  def fcm_client
    @fcm_client ||= FCM.new(ENV['FCM_SERVER_API_KEY'])
  end
end
