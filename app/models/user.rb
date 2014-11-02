class User < ActiveRecord::Base
  belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
  has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"

  attr_accessible :email

  validates :email, :uniqueness => true, :format => {:with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format."}
  validates :referral_code, :uniqueness => true

  before_create :create_referral_code
  after_create :send_welcome_email

  REFERRAL_STEPS = [
      {
          'count' => 5,
          "html" => "Barber<br>crème",
          "class" => "two",
          "image" => ActionController::Base.helpers.asset_path("/Barber créme first product.jpg")
      },
      {
          'count' => 10,
          "html" => "Mühle DE Skraber",
          "class" => "three",
          "image" => ActionController::Base.helpers.asset_path("/Mühle DE skraber 2 product.jpg")
      },
      {
          'count' => 25,
          "html" => "Mühle KOSMO<br>barbersæt",
          "class" => "four",
          "image" => ActionController::Base.helpers.asset_path("/Mühle KOSMO Barbersæt 3 product.jpg")
      },
      {
          'count' => 50,
          "html" => "Third Fields<br>ultimative Barbersæt",
          "class" => "five",
          "image" => ActionController::Base.helpers.asset_path("refer/blade-explain@2x.png")
      }
  ]

  private

  def create_referral_code
    referral_code = SecureRandom.hex(5)
    @collision = User.find_by_referral_code(referral_code)

    while !@collision.nil?
      referral_code = SecureRandom.hex(5)
      @collision = User.find_by_referral_code(referral_code)
    end

    self.referral_code = referral_code
  end

  def send_welcome_email
    UserMailer.delay.signup_email(self)
  end
end
