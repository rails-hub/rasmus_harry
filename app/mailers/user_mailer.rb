class UserMailer < ActionMailer::Base
    default from: "Thirdfield <railshub@gmail.com>"

    def signup_email(user)
        @user = user
        @twitter_message = "#Shaving is evolving. Excited for @harrys to launch."

        mail(:to => user.email, :subject => "Tak for din tilmelding!")
    end
end
