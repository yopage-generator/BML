ActiveAdmin.register Account do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    column :id
    column :created_at
    column :updated_at
    column :ident
    column :access_key
    column :name
    column :balance do |resource|
      humanized_money_with_symbol(resource.billing_account.amount)
    end
    actions do |resource|
      link_to 'Пополнить баланс', charge_balance_admin_account_url(resource), class: 'member_link'
    end
  end

  member_action :charge_balance, method: [:get, :post] do
    if request.post?
      begin
        amount = Money.new((params[:account][:balance].to_f * 100).to_i, :rub)
        Billing::GiftChargeBalance.new(account: resource, amount: amount).call
        redirect_to admin_accounts_url, flash: { success: I18n.t('flashes.activeadmin.balance_charged') }
      rescue => err
        redirect_to :back, flash: { error: err.message }
      end
    else
      render :charge_balance
    end
  end
end
