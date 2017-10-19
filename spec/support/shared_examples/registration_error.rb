# frozen_string_literal: true

RSpec.shared_examples_for 'a registration validation error' do
  it 'should not create a user' do
    expect { subject }.to_not change { User.count }
  end

  it 'should not create a user on the auth server' do
    subject
    expect(auth_client).to_not have_received(:create_user)
  end

  it 'should display an error message' do
    subject
    expect(page).to have_content(error_message)
  end
end
