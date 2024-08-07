module DateHelper
  def format_date(date)
    day_of_the_week = %w(日 月 火 水 木 金 土)[date.wday]
    "#{date.strftime('%Y年%m月%d日')}(#{day_of_the_week})"
  end
end
