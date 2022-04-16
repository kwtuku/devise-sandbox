require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }

    context 'when from GitHub' do
      subject { build(:user, :from_github) }

      it { is_expected.to validate_inclusion_of(:provider).in_array(%w[github]).allow_nil }
      it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider).allow_nil.ignoring_case_sensitivity }
    end

    context 'when from Google' do
      subject { build(:user, :from_google) }

      it { is_expected.to validate_inclusion_of(:provider).in_array(%w[google_oauth2]).allow_nil }
      it { is_expected.to validate_uniqueness_of(:uid).scoped_to(:provider).allow_nil.ignoring_case_sensitivity }
    end
  end

  describe '.from_omniauth(auth)' do
    let(:github_auth) { OmniAuth::AuthHash.new(Faker::Omniauth.github) }
    let(:google_auth) { OmniAuth::AuthHash.new(Faker::Omniauth.google) }

    context 'when new user from GitHub' do
      it 'increases User count' do
        expect { described_class.from_omniauth(github_auth) }.to change(described_class, :count).by(1)
      end

      it 'returns user' do
        expect(described_class.from_omniauth(github_auth)).to be_an_instance_of described_class
      end
    end

    context 'when existing user from GitHub' do
      let!(:user) { create(:user, :from_github, email: github_auth.info.email, uid: github_auth.uid) }

      it 'does not increase User count' do
        expect { described_class.from_omniauth(github_auth) }.to change(described_class, :count).by(0)
      end

      it 'returns user' do
        expect(described_class.from_omniauth(github_auth)).to eq user
      end
    end

    context 'when new user from Google' do
      it 'increases User count' do
        expect { described_class.from_omniauth(google_auth) }.to change(described_class, :count).by(1)
      end

      it 'returns user' do
        expect(described_class.from_omniauth(google_auth)).to be_an_instance_of described_class
      end
    end

    context 'when existing user from Google' do
      let!(:user) { create(:user, :from_google, email: google_auth.info.email, uid: google_auth.uid) }

      it 'does not increase User count' do
        expect { described_class.from_omniauth(google_auth) }.to change(described_class, :count).by(0)
      end

      it 'returns user' do
        expect(described_class.from_omniauth(google_auth)).to eq user
      end
    end
  end
end
