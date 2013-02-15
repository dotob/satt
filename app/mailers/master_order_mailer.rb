class MasterOrderMailer < ActionMailer::Base
  default from: "satt <app6607949@heroku.com>"

  def lunch_arrived_emails(master_order)
    uos = master_order.user_orders.find_all{|uo| !uo.order_items.blank?}
    emails = uos.map(&:user).map(&:email)
    mail(:to => emails, :subject => "essen von #{master_order.menu.name} is da! #{master_order.user.name} (nfm)")
  end
end
