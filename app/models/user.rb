class User < ActiveRecord::Base
  authenticates_with_sorcery!
  include UserConfirmation
  include UserPasswordReset
  include UserInvitable
  include PhoneAndEmail

  has_many :memberships, dependent: :destroy
  accepts_nested_attributes_for :memberships, reject_if: :all_blank

  has_many :accounts, through: :memberships
  has_many :phone_confirmations, autosave: true, dependent: :delete_all
  has_many :invites, dependent: :destroy, foreign_key: :user_inviter_id

  validates :name, :email, presence: true
  validates :phone, phone: true, uniqueness: true, allow_blank: true
  validates :email, email: true, uniqueness: true
  validates :password, confirmation: true

  def self.build_from_invite(invite)
    user = User.new
    user.assign_attributes invite.attributes.slice(*%w(email phone))
    user.invite_key = invite.key

    user
  end

  def available_accounts
    super_admin? ? Account.all : accounts
  end

  def super_admin?
    Settings.admin_ids.include? id
  end

  def default_account
    accounts.first || raise("User #{id} has no accounts")
  end

  def to_s
    name
  end
end
