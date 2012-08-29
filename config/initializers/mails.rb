ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => ENV['app6607949@heroku.com'],
  :password       => ENV['9ronpmfb'],
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method = :smtp