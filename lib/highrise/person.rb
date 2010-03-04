module Highrise
  class Person < Subject
    include Pagination
    include Taggable
    include Contactable
    
    def self.find_all_across_pages_since(time)
      find_all_across_pages(:params => { :since => time.utc.to_s(:db).gsub(/[^\d]/, '') })
    end

    def self.find_by_email(email)
      find(:all, :from => :search, :params => { :criteria => { :email => email } }).find { |record| record.email.downcase == email }
    end
  
    def company
      Company.find(company_id) if company_id
    end
  
    def name
      "#{first_name rescue ''} #{last_name rescue ''}".strip
    end
    
    def address
      contact_data.addresses.first
    end
    
    def web_address
      contact_data.web_addresses.first
    end
    
    def label
      'Party'
    end
  end
end
