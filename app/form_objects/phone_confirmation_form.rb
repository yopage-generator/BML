# Форма подтверждения телефона по пин-коду
class PhoneConfirmationForm < FormBase
  attribute :phone,    String
  attribute :backurl,  String
  attribute :pin_code, String
end
