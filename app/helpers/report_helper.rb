module ReportHelper
  def dump_js_date date
    # -1 because javascript start count the months from 0
    "new Date(#{date.year}, #{date.month}-1, #{date.day}, #{date.hour}, #{date.min})"
  end
end
