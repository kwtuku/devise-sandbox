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
  end

  describe '.from_omniauth(auth)' do
    let(:auth) { OmniAuth::AuthHash.new(Faker::Omniauth.github) }

    context 'when new user' do
      it 'increases User count' do
        expect { described_class.from_omniauth(auth) }.to change(described_class, :count).by(1)
      end

      it 'returns user' do
        expect(described_class.from_omniauth(auth)).to be_an_instance_of described_class
      end
    end

    context 'when existing user' do
      let!(:user) { create(:user, :from_github, email: auth.info.email, uid: auth.uid) }

      it 'does not increase User count' do
        expect { described_class.from_omniauth(auth) }.to change(described_class, :count).by(0)
      end

      it 'returns user' do
        expect(described_class.from_omniauth(auth)).to eq user
      end
    end
  end
end
