module InviteActivation
  extend ActiveSupport::Concern

  def accept!(user)
    begin
      account.memberships.create! user: user, role: role
    rescue
      ActiveRecord::RecordInvalid
    end
    destroy!
  end

  def find_and_bind_users
    w = {}
    w[:email] = email if email.present?
    w[:phone] = phone if phone.present?

    users = User.where w

    return [] unless users.any?

    users.to_a.map do |o|
      account.memberships.create(user: o, role: role) && o
    end
  end
end
