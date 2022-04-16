require 'rails_helper'

RSpec.describe 'Users::OmniauthCallbacks', type: :request do
  describe 'POST /users/auth/github/callback' do
    before do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(Faker::Omniauth.github)
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    end

    context 'when new user' do
      it 'returns found' do
        post user_github_omniauth_callback_url
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_url' do
        post user_github_omniauth_callback_url
        expect(response).to redirect_to new_user_session_url
      end

      it 'increases User count' do
        expect { post user_github_omniauth_callback_url }.to change(User, :count).by(1)
      end

      it 'has alert flash' do
        post user_github_omniauth_callback_url
        expect(flash[:alert]).to eq 'メールアドレスの本人確認が必要です。'
      end
    end

    context 'when existing confirmed user' do
      let!(:user) { create(:user, :confirmed, :from_github) }

      before do
        OmniAuth.config.mock_auth[:github].info.email = user.email
        OmniAuth.config.mock_auth[:github].uid = user.uid
      end

      it 'returns found' do
        post user_github_omniauth_callback_url
        expect(response).to have_http_status(:found)
      end

      it 'redirects to root_url' do
        post user_github_omniauth_callback_url
        expect(response).to redirect_to root_url
      end

      it 'does not increase User count' do
        expect { post user_github_omniauth_callback_url }.to change(User, :count).by(0)
      end

      it 'has correct current user' do
        post user_github_omniauth_callback_url
        expect(controller.current_user).to eq user
      end
    end
  end

  describe 'POST /users/auth/google_oauth2/callback' do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(Faker::Omniauth.google)
      Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    context 'when new user' do
      it 'returns found' do
        post user_google_oauth2_omniauth_callback_url
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new_user_session_url' do
        post user_google_oauth2_omniauth_callback_url
        expect(response).to redirect_to new_user_session_url
      end

      it 'increases User count' do
        expect { post user_google_oauth2_omniauth_callback_url }.to change(User, :count).by(1)
      end

      it 'has alert flash' do
        post user_google_oauth2_omniauth_callback_url
        expect(flash[:alert]).to eq 'メールアドレスの本人確認が必要です。'
      end
    end

    context 'when existing confirmed user' do
      let!(:user) { create(:user, :confirmed, :from_google) }

      before do
        OmniAuth.config.mock_auth[:google_oauth2].info.email = user.email
        OmniAuth.config.mock_auth[:google_oauth2].uid = user.uid
      end

      it 'returns found' do
        post user_google_oauth2_omniauth_callback_url
        expect(response).to have_http_status(:found)
      end

      it 'redirects to root_url' do
        post user_google_oauth2_omniauth_callback_url
        expect(response).to redirect_to root_url
      end

      it 'does not increase User count' do
        expect { post user_google_oauth2_omniauth_callback_url }.to change(User, :count).by(0)
      end

      it 'has correct current user' do
        post user_google_oauth2_omniauth_callback_url
        expect(controller.current_user).to eq user
      end
    end
  end
end
