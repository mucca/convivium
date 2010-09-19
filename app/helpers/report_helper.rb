module ReportHelper
  def dump_js_date date
    "new Date(#{date.year}, #{date.month}, #{date.day}, #{date.hour}, #{date.min})"
  end
end
