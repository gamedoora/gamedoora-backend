# frozen_string_literal: true

# User Model related to users table
# table_name => users

class User < ApplicationRecord
  # encrypt password
  has_secure_password

  # Validations
  validates_presence_of :first_name, :email, :password_digest
  validates_uniqueness_of :email


  def complete_name_view
    name = first_name.titleize
    name += "#{name} #{middle_name.titleize}" if middle_name.present?
    name += "#{name} #{last_name.titleize}" if last_name.present?
    name
  end


end
