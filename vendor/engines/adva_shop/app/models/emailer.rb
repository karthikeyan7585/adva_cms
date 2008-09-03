#DEVNOTE - Rename this as OrderMailer
class Emailer < ActionMailer::Base
  
  def contact(receipient, subject)
    @subject = subject
    @recipients = receipient
    #DEVNOTE -  From address should come from config
    @from   =   'advacms@aspiresys.com'
    @sent_on  = Time.now
    @body["title"] = "from adva shopping cart"

    @body["message"] = "your pay has been recived."  
  @headers = {}

    end
end 