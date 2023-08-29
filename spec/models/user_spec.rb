require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'must be created with password and password_confirmation fields' do
      user = User.new(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      expect(user.save).to be(true)
    end

    it 'password and password_confirmation must match' do
      user = User.new(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password'
      )
      expect(user.save).to be(false)
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end

    it 'requires password and password_confirmation when creating the model' do
      user = User.new(
        name: 'John Doe',
        email: 'test@example.com'
      )
      user.save
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'emails must be unique (case-insensitive)' do
      User.create(
        name: 'Jane Doe',
        email: 'test@test.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      user = User.new(
        name: 'John Doe',
        email: 'TEST@TEST.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      user.save
      expect(user.errors[:email]).to include('has already been taken')
    end

    it 'requires name, email, and password' do
      user = User.new
      user.save
      expect(user.errors[:name]).to include("can't be blank")
      expect(user.errors[:email]).to include("can't be blank")
      expect(user.errors[:password]).to include("can't be blank")
    end
  end
  
  describe '.authenticate_with_credentials' do
    it 'authenticates with valid credentials' do
      user = User.create(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'password123')
      expect(authenticated_user).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user = User.create(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      authenticated_user = User.authenticate_with_credentials('test@example.com', 'password')
      expect(authenticated_user).to be_nil
    end

    it 'authenticates with email containing leading/trailing spaces' do
      user = User.create(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      authenticated_user = User.authenticate_with_credentials('  test@example.com  ', 'password123')
      expect(authenticated_user).to eq(user)
    end

    it 'authenticates with email in different case' do
      user = User.create(
        name: 'John Doe',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      )
      authenticated_user = User.authenticate_with_credentials('Test@Example.com', 'password123')
      expect(authenticated_user).to eq(user)
    end
    
  end
end