require 'spec_helper'

RSpec.describe 'Auth routes' do
  describe 'GET /auth/login' do
    it 'returns success' do
      get '/auth/login'
      expect(last_response).to be_ok
    end
  end

  describe 'POST /auth/login' do
    let!(:user) { User.create!(email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      it 'logs in the user' do
        post '/auth/login', { email: 'test@example.com', password: 'password123' }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/')
      end
    end

    context 'with invalid credentials' do
      it 'does not log in the user' do
        post '/auth/login', { email: 'test@example.com', password: 'wrongpassword' }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/auth/login')
      end
    end
  end

  describe 'GET /auth/register' do
    it 'returns success' do
      get '/auth/register'
      expect(last_response).to be_ok
    end
  end

  describe 'POST /auth/register' do
    context 'with valid attributes' do
      it 'creates a user and logs in' do
        post '/auth/register', {
          email: 'new@example.com',
          password: 'password123',
          password_confirmation: 'password123'
        }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/')
        expect(User.find_by(email: 'new@example.com')).to be_present
      end
    end

    context 'with invalid attributes' do
      it 'does not create a user' do
        post '/auth/register', {
          email: 'invalid-email',
          password: '123',
          password_confirmation: '123'
        }
        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.path).to eq('/auth/register')
        expect(User.find_by(email: 'invalid-email')).to be_nil
      end
    end
  end

  describe 'GET /auth/logout' do
    it 'logs out the user' do
      post '/auth/login', { email: 'test@example.com', password: 'password123' }
      get '/auth/logout'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.path).to eq('/')
    end
  end
end
