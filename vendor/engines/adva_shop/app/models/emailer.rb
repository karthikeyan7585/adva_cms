class Emailer < ActionMailer::Base
  
  def contact(receipient, subject)
    @subject = subject
    @recipients = receipient
    
    @from   =   'advacms@aspiresys.com'
    @sent_on  = Time.now
    @body["title"] = "from adva shopping cart"

    @body["message"] = "your pay has been recived."  
  @headers = {}

    end
end 