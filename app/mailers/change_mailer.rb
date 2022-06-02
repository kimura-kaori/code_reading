class ChangeMailer < ApplicationMailer
  def send_message_to_user(user)

      @user = user
      mail to: @user.email, subject: "リーダーを変更しました"    
    end
  end
