# client = IEX::Api::Client.new(
#   publishable_token: 'pk_79541eba9c3b47a89aad63f6efc2b5ab',
#   secret_token: 'sk_087ab8ff2fd5419aacc349b11ecf0868',
#   endpoint: 'https://cloud.iexapis.com/v1'
# )

IEX::Api.configure do |config|
  config.publishable_token = 'pk_79541eba9c3b47a89aad63f6efc2b5ab' # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
  config.secret_token = 'sk_087ab8ff2fd5419aacc349b11ecf0868' # defaults to ENV['IEX_API_SECRET_TOKEN']
  config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
end