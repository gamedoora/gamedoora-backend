# frozen_string_literal: true

# User Model related to users table
# table_name => users

class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # Validations
  validates_presence_of :first_name, :email, :password_digest


end
