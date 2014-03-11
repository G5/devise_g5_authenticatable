shared_context 'OAuth2::Error' do
  let(:oauth_error) { OAuth2::Error.new(oauth_response) }
  let(:oauth_response) do
    double(:oauth_response,
           parsed: {'error' => error_message}).as_null_object
  end

  let(:error_message) { 'Validation failed: Email is already taken' }
end
