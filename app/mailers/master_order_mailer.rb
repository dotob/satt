class MasterOrderMailer < ActionMailer::Base
  default from: "sk@dotob.de"

  def lunch_arrived_emails(master_order)
    emails = master_order.user_orders.map(&:user).map(&:email)
    mail(:to => emails, :subject => "essen von #{master_order.menu.name} is da! #{master_order.user.name} (nfm)")
  end
end
