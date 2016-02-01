class Account < ActiveRecord::Base
  include AccountAccessKey
  include AccountIdent

  has_many :landings,    dependent: :destroy
  has_many :collections, dependent: :destroy

  has_many :versions, through: :landings

  has_many :asset_files, dependent: :destroy
  has_many :asset_images

  has_many :authentications, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  def to_s
    "Аккаунт #{id}"
  end

  def subdomain
    AccountConstraint::DOMAIN_PREFIX + ident
  end

  def api_key
    access_key
  end
end
