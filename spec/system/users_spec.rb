require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'signs up' do
    context 'with email' do
      it 'works' do
        visit root_path
        click_link 'アカウント登録'
        fill_in 'Eメール', with: 'user@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        expect { click_button 'アカウント登録' }.to change(User, :count).by(1)
        expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクからアカウントを有効化させてください。'
      end
    end

    context 'with GitHub' do
      before do
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(Faker::Omniauth.github)
        Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
        Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      end

      it 'works' do
        visit root_path
        click_link 'アカウント登録'
        expect { click_link 'GitHubでログイン' }.to change(User, :count).by(1)
        expect(page).to have_content 'メールアドレスの本人確認が必要です。'
      end
    end
  end

  describe 'signs in' do
    context 'with email' do
      let!(:user) { create(:user, :confirmed) }

      it 'works' do
        visit root_path
        click_link 'ログイン'
        fill_in 'Eメール', with: user.email
        fill_in 'パスワード', with: user.password
        expect { click_button 'ログイン' }.to change(User, :count).by(0)
        expect(page).to have_content user.email
      end
    end

    context 'with GitHub' do
      let!(:user) { create(:user, :confirmed, :from_github) }

      before do
        OmniAuth.config.mock_auth[:github].info.email = user.email
        OmniAuth.config.mock_auth[:github].uid = user.uid
      end

      it 'works' do
        visit root_path
        click_link 'ログイン'
        expect { click_link 'GitHubでログイン' }.to change(User, :count).by(0)
        expect(page).to have_content user.email
      end
    end
  end
end
