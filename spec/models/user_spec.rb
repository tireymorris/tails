require 'spec_helper'

RSpec.describe User do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(email: 'test@example.com', password: 'password123')
      expect(user).to be_valid
    end

    it 'is invalid without email' do
      user = User.new(password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with duplicate email' do
      User.create!(email: 'test@example.com', password: 'password123')
      user = User.new(email: 'test@example.com', password: 'password456')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'is invalid with invalid email format' do
      user = User.new(email: 'invalid-email', password: 'password123')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'is invalid with short password' do
      user = User.new(email: 'test@example.com', password: '12345')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
    end
  end

  describe 'authentication' do
    let(:user) { User.create!(email: 'test@example.com', password: 'password123') }

    it 'authenticates with correct password' do
      authenticated_user = user.authenticate('password123')
      expect(authenticated_user).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      authenticated_user = user.authenticate('wrongpassword')
      expect(authenticated_user).to be_falsey
    end
  end
end
