##
# Returns a Google::Cloud::Datastore::Dataset object for the configured dataset.
#
# The dataset instance is used to create, read, update, and delete entity objects.
#
# GOOGLE_CLOUD_PROJECT is an environment variable representing the Datastore project ID.
# GOOGLE_APPLICATION_CREDENTIALS/GOOGLE_CLOUD_KEYFILE is an environment variable that Datastore checks for credentials.
#
# ENV['GOOGLE_CLOUD_KEYFILE'] = '{
#   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIFfb3...5dmFtABy\n-----END PRIVATE KEY-----\n",
#   "client_email": "web-app@app-name.iam.gserviceaccount.com"
# }'
#
module CloudDatastore
  if defined?(Rails) == 'constant'
    if not ENV['GOOGLE_APPLICATION_CREDENTIALS'].present?
      if ENV['SERVICE_ACCOUNT_PRIVATE_KEY'].present? && ENV['SERVICE_ACCOUNT_CLIENT_EMAIL'].present?
        ENV['GOOGLE_CLOUD_KEYFILE'] ||= '{"private_key": "' + ENV['SERVICE_ACCOUNT_PRIVATE_KEY'] + '","client_email": "' + ENV['SERVICE_ACCOUNT_CLIENT_EMAIL'] + '"}'
      elsif Rails.env.development?
        ENV['DATASTORE_EMULATOR_HOST'] ||= 'localhost:8180'
        ENV['GOOGLE_CLOUD_PROJECT'] ||= 'local-datastore'
      elsif Rails.env.test?
        ENV['DATASTORE_EMULATOR_HOST'] ||= 'localhost:8181'
        ENV['GOOGLE_CLOUD_PROJECT'] ||= 'test-datastore'
      end
    end
  end

  def self.dataset
    timeout = ENV.fetch('DATASTORE_NETWORK_TIMEOUT', 15).to_i
    @dataset ||= Google::Cloud.datastore(timeout: timeout)
  end

  def self.reset_dataset
    @dataset = nil
  end
end
