module ActiveRecord # :nodoc:
  class Base # :nodoc:

    def write_attribute_with_date_cast(attr, value)
      if column_for_attribute(attr) and column_for_attribute(attr).klass == Date
        value = cast_to_date(value) unless value.nil?
      end
      write_attribute_without_date_cast(attr, value)
    end
    alias_method_chain :write_attribute, :date_cast

    cattr_accessor :dhtml_db_date_format
    @@dhtml_db_date_format = '%Y-%m-%d'

    def cast_to_date(value)
      case value
      when String
        begin
          if Date.respond_to?(:un_localize)
            d = Date.un_localize(value)
          else
            d = Date.strptime(value, ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default])
          end
        rescue
          begin
            # format = if Date.respond_to?(localize_format)
            format ||= ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default]
            d = Date.strptime(value, format)
          rescue
            # The challenge here is DHTMCalendar allows string input such as "today", and the .js is not completely validating input. 
            # Until then we need to handle the condition where a bad value was input.
            # To that end we will return a value that can be validated against as being a bad value in a in the form of 0000-01-01
            # Add the following to your validate method in your model
            #   errors.add :funding_on, "Funding date must be after 1-1-2000." if funding_on and (funding_on < Date.new(2000,1,1))
            d =  Date.new(0,1,1)
          end
        end
        d.strftime(ActiveRecord::Base.dhtml_db_date_format)
      when Date, Time, DateTime
        value
      else
        raise ArgumentError, "Argument for cast_to_date must be a String, Date, or Time; was: #{value.inspect}, #{value.class}" 
      end
    end
  end
end

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module Quoting
      # Quotes the column value to help prevent
      # {SQL injection attacks}[http://en.wikipedia.org/wiki/SQL_injection].
      def quote_with_date_cast(value, column = nil)
        # records are quoted as their primary key
        return value.quoted_id if value.respond_to?(:quoted_id)

        case value
          # Treat Date the same as Time and DateTime, Rails was calling value.to_s
          # PostgreSQL adapter, the quoted_date method expects it to be a Time object
          #FIXME 2007-10-04 (EJM) Level=0 - Should we be using local or another method or does it matter since we are setting time to 0,0,0 ?
        when Date then "'#{quoted_date(Time.local(value.year, value.month, value.day, 0, 0, 0))}'"
        else            quote_without_date_cast(value, column)
        end
      end
      alias_method_chain :quote, :date_cast
    end
  end
end