module Highrise
  module Contactable

    class EmailAddress
      attr_accessor :address
      attr_accessor :location
      
      def initialize(address, location)
        self.address = address
        self.location = location
      end
      
      def to_xml
        { :address => address, :location => location }.to_xml
      end
    end

    class PhoneNumber
      attr_accessor :number
      attr_accessor :location

      def initialize(number, location)
        self.number = number
        self.location = location
      end
      
      def to_xml
        { :number => number, :location => location }.to_xml
      end
    end
    
    def self.included(base)
      base.send :include, InstanceMethods
    end
    
    module InstanceMethods
      def email(location = :work)
        find_by_location(contact_data.email_addresses, location).address
      rescue
        ''
      end

      def email=(email, location = :work)
        if data = find_by_location(contact_data.email_addresses, location)
          data.address = email
        else
          contact_data.email_addresses << EmailAddress(email, location)
        end
      end
      
      def phone_number(location = :work)
        find_by_location(contact_data.phone_numbers, location).number
      rescue
        ''
      end

      def phone_number=(number, location = :work)
        if data = find_by_location(contact_data.phone_numbers, location)
          data.number = number
        else
          contact_data.phone_numbers << PhoneNumber(number, location)
        end
      end
      
      private
      
      def find_by_location(collection, location)
        collection.find { |record| record.location.downcase == location.to_s.downcase }
      end
      
    end

  end
end
