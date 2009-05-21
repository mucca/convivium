require 'date'
##
## Load the library
##
require "#{File.dirname __FILE__}/lib/helpers/calendar"
require "#{File.dirname __FILE__}/lib/extensions/active_record"

##
## Inject includes for libraries
##

ActionView::Base.send(:include, ActionView::Helpers::DhtmlCalendarHelper)

##
## Set Default date formats. Change these to your liking in your environment.rb or in application.rb
##
ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] ||= '%Y-%m-%d'
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default] ||= '%Y-%m-%d %H:%M:%S'