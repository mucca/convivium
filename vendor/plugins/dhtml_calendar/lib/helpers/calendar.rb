# The Calendar Helper methods create HTML code for different variants of the
# Dynarch DHTML/JavaScript Calendar.
#
# Author: Michael Schuerig, <a href="mailto:michael@schuerig.de">michael@schuerig.de</a>, 2005
# Free for all uses. No warranty or anything. Comments welcome.
#
# Version 0.02:
# Always set calendar_options's ifFormat value to '%Y/%m/%d %H:%M:%S'
# so that the calendar recieves the object's time of day.  Previously,
# the '%c' formating used to set the initial date would be parsed by
# the JavaScript calendar correctly to find the date, but it would not
# pick up the time of day.
#
# Version 0.01:
# Original version by Michael Schuerig.
#
#
# Modified for inclusion in DhtmlCalendar by Ed Moss, 4ssoM LLC
#
# == Common Options
#
# The +html_options+ argument is passed through mostly verbatim to the
# +text_field+, +hidden_field+, and +image_tag+ helpers.
# The +title+ attributes are handled specially, +field_title+ and
# +button_title+ appear only on the respective elements as +title+.
#
# The +calendar_options+ argument accepts all the options of the
# JavaScript +Calendar.setup+ method defined in +calendar-setup.js+.
# The ifFormat option for +Calendar.setup+ is set up with a default
# value that sets the calendar's date and time to the object's value,
# so only set it if you need to send less specific times to the
# calendar, such as not setting the number of seconds.
#
module ActionView::Helpers
  module DhtmlCalendarHelper
    
    # Add this to your layout 
    # <%= dhtml_calendar_includes %>
    # or
    # <%= dhtml_calendar_includes("blue", "en") %>
    # Optional parameters:
    # * <tt>color</tt> - Default value is +blue+.
    # * <tt>language</tt> - Default value is +en+.
    # Look in the plugins public/javascripts folder for possible values
    def dhtml_calendar_includes(color = "blue", language = "en")
      language ||= "en"
      lang_file = "#{asset_path}lang/calendar-#{language}.js"
      lang_file = "#{asset_path}lang/calendar-#{language[0..1]}.js" unless File.exists?(File.join(RAILS_ROOT, 'public', 'javascripts', lang_file))
      lang_file = "#{asset_path}lang/calendar-en.js" unless File.exists?(File.join(RAILS_ROOT, 'public', 'javascripts', lang_file))
      javascript_include_tag("#{asset_path}datebox_engine.js") + "\n" + 
      javascript_include_tag("#{asset_path}calendar.js") + "\n" + 
      javascript_include_tag(lang_file) + "\n" + 
      javascript_include_tag("#{asset_path}calendar-setup.js") + "\n" + 
      stylesheet_link_tag("#{asset_path}dhtml_calendar.css") + "\n" + 
      stylesheet_link_tag("#{asset_path}calendar-#{color}.css")
    end

    def asset_path
      "dhtml_calendar/"
    end
    
    def active_scaffold_input_calendar(column, options)
      sub_type = column.options[:sub_type] || :box
      form_name = element_form_id(:action => :create) if [:new, :create].include?(params[:action].to_sym)
      form_name = search_form_id if [:show_search].include?(params[:action].to_sym)
      form_name = element_form_id(:action => :update) if [:edit, :update].include?(params[:action].to_sym)
      if defined? ActiveScaffold::Helpers
        calendar_options = default_calendar_options(column.options)
        calendar_options.merge!(:showsTime => 1) if calendar_options[:showsTime].nil? and column.column.type == :datetime
        calendar_options[:display_format] = as_(options[:display_format]) if options[:display_format]
        calendar_options[:help_string] = as_(options[:help_string] || column.options[:help_string]) if options[:help_string] || column.options[:help_string]
        calendar_options[:title] = as_(options[:title]) if options[:title]
        
        # Localize the date and calendar_options?
        if defined? ActiveScaffold::Localization
          date = @record.send(column.name) if @record
          options[:value] = date.localize if date and date.respond_to?(:localize)
          if ActiveScaffold::Localization.lookup(:date_helper)
            calendar_options[:display_format] ||= ActiveScaffold::Localization.lookup(:date_helper)[:date_helper_date_formats][:default] if ActiveScaffold::Localization.lookup(:date_helper)[:date_helper_date_formats]
            calendar_options[:help_string] ||= ActiveScaffold::Localization.lookup(:date_helper)[:calendar_help]
            calendar_options[:title] ||= ActiveScaffold::Localization.lookup(:date_helper)[:calendar_tool_tip]
          end
        end
        calendar_tag(:record, column.name, sub_type, 
               { :form_name => form_name,
                 :include_blank => true,
                 :use_month_numbers => true }.merge(options.merge(active_scaffold_input_text_options(:class => options[:class]))), calendar_options)
      else
        date_select(:record, column.name, options)
      end
    end

    def default_calendar_options(options = {})
      default_options = {}
      default_options[:firstDay] = options[:firstDay] || 1
      default_options[:range] = options[:range] || [Date.today.year - 5, Date.today.year + 20]
      default_options[:step] = options[:step] || 1
      default_options[:showOthers] = options[:showOthers] || true
      default_options[:cache] = options[:cache] || true
      default_options
    end

    # Returns HTML code for a calendar that pops up when the calendar image is
    # clicked.
    # 
    # Note: :form_name is optional unless your form is named. If it is named then supply 
    #   the name of the form.
    #
    # Example:
    #
    #  <%= popup_calendar 'person', 'birthday',
    #        { :class => 'date',
    #          :field_title => 'Birthday',
    #          :form_name => 'custform',
    #          :button_image => 'calendar.gif',
    #          :button_title => 'Show calendar' },
    #        { :firstDay => 1,
    #          :range => [1920, 1990],
    #          :step => 1,
    #          :showOthers => true,
    #          :cache => true }
    #  %>
    #
    def popup_calendar(object, method, html_options = {}, calendar_options = {})
      calendar_tag(object, method, :popup, html_options, calendar_options)
    end

    # Returns HTML code for a flat calendar.
    #
    # Note: :form_name is optional unless your form is named. If it is named then supply 
    #   the name of the form.
    #
    # Example:
    #
    #  <%= calendar 'person', 'birthday',
    #        { :class => 'date' ,
    #          :form_name => 'custform'},
    #        { :firstDay => 1,
    #          :range => [1920, 1990],
    #          :step => 1,
    #          :showOthers => true }
    #  %>
    #
    def _calendar(object, method, html_options = {}, calendar_options = {})
      calendar_tag(object, method, :flat, html_options, calendar_options)
    end

    # Returns HTML code for a date field and calendar that pops up when the
    # calendar image is clicked.
    #
    # Note: :form_name is optional unless your form is named. If it is named then supply 
    #   the name of the form.
    #
    # Example:
    #
    #  <%= calendar_field 'person', 'birthday',
    #        { :class => 'date',
    #          :date => value,
    #          :field_title => 'Birthday',
    #          :form_name => 'custform',
    #          :button_title => 'Show calendar' },
    #        { :firstDay => 1,
    #          :range => [1920, 1990],
    #          :step => 1,
    #          :showOthers => true,
    #          :cache => true }
    #  %>
    #
    def calendar_field(object, method, html_options = {}, calendar_options = {})
      calendar_tag(object, method, :field, html_options, calendar_options)
    end

    # Returns HTML code for a DateBocks style date field and calendar that pops up when the
    # calendar image is clicked.
    #
    # Note: :form_name is optional unless your form is named. If it is named then supply 
    #   the name of the form.
    #
    # Example:
    #
    #  <%= calendar_box 'person', 'birthday',
    #        { :class => 'date',
    #          :date => value,
    #          :field_title => 'Birthday',
    #          :form_name => 'custform',
    #          :button_title => 'Show calendar' },
    #        { :firstDay => 1,
    #          :range => [1920, 1990],
    #          :step => 1,
    #          :showOthers => true,
    #          :cache => true }
    #  %>
    #
    # options
    # 
    #    prop. name               | description
    #  -------------------------------------------------------------------------------------------------
    #   dateType                  | the format to display the date (iso, de, us, dd/mm/yyyy, dd-mm-yyyy, mm/dd/yyyy, mm.dd.yyyy, yyyy-mm-dd)
    #   calendarAlign             | where to align the calendar (can also be set in the calendar_options) (Ex: Br, Bl, Tl, Tr) 
    #   messageSpanSuffix         | default is 'Msg'
    #   messageSpanErrorClass     | default is 'error'
    #   messageSpanSuccessClass   | default is ''
  
    # calendar_options
    # 
    # To use javascript code as a value, prefix with "javascript:"
    # 
    #    prop. name   | description
    #  -------------------------------------------------------------------------------------------------
    #   inputField    | the ID of an input field to store the date
    #   displayArea   | the ID of a DIV or other element to show the date
    #   button        | ID of a button or other element that will trigger the calendar
    #   eventName     | event that will trigger the calendar, without the "on" prefix (default: "click")
    #   ifFormat      | date format that will be stored in the input field
    #   daFormat      | the date format that will be used to display the date in displayArea
    #   singleClick   | (true/false) wether the calendar is in single click mode or not (default: true)
    #   firstDay      | numeric: 0 to 6.  "0" means display Sunday first, "1" means display Monday first, etc.
    #   align         | alignment (default: "Br"); if you don't know what's this see the calendar documentation
    #   range         | array with 2 elements.  Default: [1900, 2999] -- the range of years available
    #   weekNumbers   | (true/false) if it's true (default) the calendar will display week numbers
    #   flat          | null or element ID; if not null the calendar will be a flat calendar having the parent with the given ID
    #   flatCallback  | function that receives a JS Date object and returns an URL to point the browser to (for flat calendar)
    #   disableFunc   | function that receives a JS Date object and should return true if that date has to be disabled in the calendar
    #   onSelect      | function that gets called when a date is selected.  You don't _have_ to supply this (the default is generally okay)
    #   onClose       | function that gets called when the calendar is closed.  [default]
    #   onUpdate      | function that gets called after the date is updated in the input field.  Receives a reference to the calendar.
    #   date          | the date that the calendar will be initially displayed to
    #   showsTime     | default: false; if true the calendar will include a time selector
    #   timeFormat    | the time format; can be "12" or "24", default is "12"
    #   electric      | if true (default) then given fields/date areas are updated for each move; otherwise they're updated only on close
    #   step          | configures the step of the years in drop-down boxes; default: 2
    #   position      | configures the calendar absolute position; default: null
    #   cache         | if "true" (but default: "false") it will reuse the same calendar object, where possible
    #   showOthers    | if "true" (but default: "false") it will show days from other months too
    def calendar_box(object, method, html_options = {}, calendar_options = {})
      calendar_tag(object, method, :box, html_options, calendar_options)
    end

    # Returns HTML code for Rails like drop-down controls and calendar that pops up when the
    # calendar image is clicked.
    #
    # Note: :form_name is optional unless your form is named. If it is named then supply 
    #   the name of the form.
    #
    # Example:
    #
    #  <%= calendar_select 'person', 'birthday',
    #        { :class => 'date',
    #          :date => value,
    #          :field_title => 'Birthday',
    #          :form_name => 'custform',
    #          :button_title => 'Show calendar' },
    #        { :firstDay => 1,
    #          :range => [1920, 1990],
    #          :step => 1,
    #          :showOthers => true,
    #        	 :showsTime => true,
    #        	 :timeFormat => 12,
    #          :cache => true }
    #  %>
    #
    def calendar_select(object, method, html_options = {}, calendar_options = {})
      calendar_tag(object, method, :select, html_options, calendar_options)
    end

    private

    # Note:
    #   :box and bocks behave the same. :box is a simplified version - no msg input id.
    #   :bocks is maintained for backward compatibility
    def calendar_tag(object, method, show_field, html_options = {}, calendar_options = {})
      if calendar_options.has_key?(:showsTime) and calendar_options[:showsTime]
        date_format = calendar_options[:display_format] || ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default]
      else
        date_format = calendar_options[:display_format] || ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default]
      end
      
      button_image = html_options[:button_image] || 'calendar.gif'

      show_field ||= :box
      calendar_options[:popup] = true unless calendar_options.has_key?(:popup) or show_field == :field or show_field == :flat

      input_field_name = html_options[:name] || "#{object}[#{method}]" 
      input_field_id = html_options[:id] || "#{object}_#{method}" 
      calendar_id = "#{input_field_id}_calendar" 
      help_id = "#{input_field_id}_help"
      if show_field == :select
        input_field_year_id = "#{object}[#{method}(1i)]" 
        input_field_month_id = "#{object}[#{method}(2i)]" 
        input_field_day_id = "#{object}[#{method}(3i)]" 
        if calendar_options.has_key?(:showsTime) and calendar_options[:showsTime]
          input_field_hour_id = "#{object}[#{method}(4i)]" 
          input_field_minute_id = "#{object}[#{method}(5i)]" 
        end
      end
    

      if calendar_options[:popup]
        cal_button_options = {}
        [:class, :button_title].each {|key| cal_button_options[key] = html_options[key]}
        cal_button_options.merge!( 
                :alt => 'Calendar',
                :id => calendar_id,
                :style => "cursor: pointer;")
        cal_button_options[:button_title] = cal_button_options.delete(:button_title) if cal_button_options[:button_title]
        cal_button_options[:title] = calendar_options[:title] || 'Click to Show Calendar
  or try these Shortcuts:
      today (tod)
      tomorrow (tom)
      yesterday
      6 (6th or 6th October)
      3rd of Feb
      10th Feb 2004
      14th of Februrary
      12 feb
      mon
      next mon
      last mon
      2004-04-04
      1/24/2005 (US)
      4/26
      10-24-2005'
        cal_button_options.delete(:field_title)
        cal_button_options[:engine] ||= 'dhtml_calendar'
        calendar = image_tag("#{asset_path}#{button_image}", cal_button_options)
      elsif show_field == :field
        calendar = ''
      else
        calendar = "<div id=\"#{calendar_id}\" class=\"#{html_options[:class]}\"></div>" 
      end

      field_options = {:name => input_field_name, :id => input_field_id}
      [:class, :size, :value].each {|key| field_options[key] = html_options[key]}
      field_options[:size] ||= 18
      if show_field != :box and show_field != :bocks
        # DateBocks does it's own formatting
        date = self.instance_variable_get("@#{object}").send(method) if self.instance_variable_get("@#{object}")
        calendar_options[:ifFormat] ||= date_format
        field_options[:value] ||= date if date && date.strftime(calendar_options[:ifFormat])
      end
    
      field_options[:field_title] = field_options.delete(:title) if field_options[:title]
      field_options.delete(:button_title)
      case show_field
      when :select
        calendar_options[:range] ||= [Date.today.year - 5, Date.today.year + 15]
        field_options[:start_year] = calendar_options[:range][0]
        field_options[:end_year] = calendar_options[:range][1]
        if calendar_options.has_key?(:showsTime) and calendar_options[:showsTime]
          field = datetime_select(object, method, field_options)
        else
          field = date_select(object, method, field_options)
        end
      when :field
        field = text_field(object, method, field_options)
      when :bocks
        help_button_options = {}
        help_button_options.merge!(
                :alt => 'Help',
                :id => help_id,
                :style => "cursor: pointer;",
                :title => "Show Help",
                :engine => 'dhtml_calendar')
        field = 
          content_tag("div",
        	        (content_tag("ul",
            	      content_tag("li", 
            	        text_field(object, method,
            	          field_options.merge(
            	            :onChange => "magicDate('#{input_field_id}', '#{date_format}');", 
            	            :onKeyPress => "magicDateOnlyOnSubmit('#{input_field_id}', '#{date_format}', event); return dateBocksKeyListener(event);", 
            	            :onClick => "this.select();")
            	        )
            	      ) +
         	          content_tag("li", calendar)
            ) + 
            content_tag("div", 
              content_tag("div", "", :id => "#{input_field_id}Msg"), :id => "dateBocksMessage", :class => "dateBocksMessage")
            ), :class => "dateBocks") + content_tag("div", " ", :class => "dateBocksClear")
         # field = content_tag("p", field)
      when :box
        help_button_options = {}
        field = text_field(object, method,
           	          field_options.merge(
           	            :onChange => "magicDate('#{input_field_id}', '#{date_format}');", 
           	            :onKeyPress => "magicDateOnlyOnSubmit('#{input_field_id}', '#{date_format}', event); return dateBocksKeyListener(event);", 
           	            :onClick => "this.select();")
           	        )
      else
        field = hidden_field(object, method, field_options) + content_tag("div", "", :id => calendar_id)
      end

      calendar_setup = calendar_options.dup
      calendar_setup.delete(:sub_type)
      calendar_setup[:inputField] = input_field_id
      calendar_setup[:button] = calendar_id if calendar_options[:popup] and show_field != :flat
      if show_field == :flat
        calendar_setup.delete(:popup)
        calendar_setup.delete(:inputField)
        calendar_setup[:displayArea] = input_field_id
        calendar_setup[:flat] = calendar_id
      end
      calendar_setup[:formName] = html_options[:form_name] unless html_options[:form_name].nil?
      case show_field
      when :box, :bocks
        calendar_setup.merge!(
          :ifFormat => date_format,
          :align => "Br",
          :help => help_id,
          :singleClick => true)
      when :select
        calendar_setup.merge!(
          :inputFieldDay => input_field_day_id,
          :inputFieldMonth => input_field_month_id,
          :inputFieldYear => input_field_year_id
        )
        if calendar_options.has_key?(:showsTime) and calendar_options[:showsTime]
          calendar_setup.merge!(
            :inputFieldHour => input_field_hour_id,
            :inputFieldMinute => input_field_minute_id
          )
        end
      end
      case show_field
      when :bocks
<<END
#{field}
<script type="text/javascript">
  document.getElementById('#{input_field_id}Msg').innerHTML = calendarFormatString;
  Calendar.setup({ #{format_js_hash(calendar_setup)} });
</script>
END
      else
        text_field_with_example_begin = text_field_with_example_end = ""
        
        # if calendar_options[:help_string] and calendar_options[:help_string].length > 0
        #   text_field_with_example_begin = "<div class=\"field\"><label class=\"overlabel\" for=\"#{input_field_id}\">#{calendar_options[:help_string]}</label>"
        #   text_field_with_example_end = '</div>'
        # end
        calendar_setup.delete(:class) # IE and Safari don't like this in Calendar.setup
<<END
#{text_field_with_example_begin}
#{field}
#{text_field_with_example_end}
#{calendar}
<script type="text/javascript">
  Calendar.setup({ #{format_js_hash(calendar_setup)} });
</script>
END
      end
    end

    def format_js_hash(options)
      options.collect { |key,value| key.to_s + ':' + if ['flatCallback', 'disableFunc', 'onSelect', 
      'onClose', 'onUpdate', 'DateStatusFunc'].include?(key.to_s) then value else value.inspect end }.join(',')
    end
  end
end
