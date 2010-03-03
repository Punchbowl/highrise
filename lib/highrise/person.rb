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

# CREATION
# >> dd = { :first_name => "Bob", :company_name => "Innotech", :contact_data => { :email_addresses => [ { :address => "bob@innotech.com", :location => "Work" } ], :phone_numbers => [ { :number => "555.111.1234", :location => "Work" } ] } }
# => {:contact_data=>{:email_addresses=>[{:location=>"Work", :address=>"bob@innotech.com"}], :phone_numbers=>[{:location=>"Work", :number=>"555.111.1234"}]}, :company_name=>"Innotech", :first_name=>"Bob"}
# >> dd
# => {:contact_data=>{:email_addresses=>[{:location=>"Work", :address=>"bob@innotech.com"}], :phone_numbers=>[{:location=>"Work", :number=>"555.111.1234"}]}, :company_name=>"Innotech", :first_name=>"Bob"}
# >> bob = Highrise::Person.create(dd)

# NOTE
# Highrise::Note.create( { :subject_id => bob.id, :subject_type => 'Person', :body => "New lead was just created!" } )
# Highrise::Note.create( { :subject_id => bob.id, :subject_type => 'Person', :body => "Was tagged as a lead at #{Time.now}" } )

# TASK
# >> Highrise::Task.create( :subject_id => bob.id, :subject_type => "Person", :frame => "today", :body => "Follow-up with Bob Lundberg @ Innotech" )
# => #<Highrise::Task:0x35dbfe4 @prefix_options={}, @attributes={"alert_at"=>Thu Mar 04 00:00:00 UTC 2010, "updated_at"=>Wed Mar 03 21:00:55 UTC 2010, "subject_name"=>"Bob Lundberg", "public"=>false, "recording_id"=>nil, "body"=>"Follow-up with Bob Lundberg @ Innotech", "id"=>5630215, "category_id"=>nil, "frame"=>"today", "subject_type"=>"Party", "owner_id"=>234659, "subject_id"=>32938799, "author_id"=>234659, "due_at"=>Thu Mar 04 05:00:00 UTC 2010, "done_at"=>nil, "created_at"=>Wed Mar 03 21:00:55 UTC 2010}>
