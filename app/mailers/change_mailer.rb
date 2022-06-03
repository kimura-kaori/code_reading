class ChangeMailer < ApplicationMailer
  def send_message_to_user(user)
    @user = user
    mail to: @user.email, subject: "削除しました"
  end
end
