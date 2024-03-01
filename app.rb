require 'line/bot'
require 'date'

require 'dotenv' # ローカル環境用
Dotenv.load

# LINE APIにアクセスするためのインスタンスを作成
def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_secret = ENV['LINEBOT_CHANNEL_SECRET']
    config.channel_token = ENV['LINEBOT_ACCESS_TOKEN']
  }
end

# 生後の日数を計算
def calculate_age_in_weeks_and_days
  age_in_days = (TODAY - BIRTH_DATE).to_i
  age_in_days_text = "#{age_in_days}日"

  "#{year_month_day}\n#{weeks_and_days_text(age_in_days)}\n#{age_in_days}日"
end

# 生後の週数と日数を計算
def weeks_and_days_text(age_in_days)
  passed_weeks, passed_days = age_in_days.divmod(7)
  "#{passed_weeks}週#{passed_days}日"
end

# 何才何ヶ月何日か？を生成する
def year_month_day
  if TODAY_MONTH >= BIRTH_MONTH
    # 例: 今が5月で誕生月が3月なら5 - 3で2ヶ月
    passed_month = TODAY_MONTH - BIRTH_MONTH
  else
    # 例: 今が3月で誕生月が5月なら12 - (5 -3)で10ヶ月
    passed_month = 12 - (BIRTH_MONTH - TODAY_MONTH)
  end

  if TODAY_DAT_NUM >= BIRTH_DAY_NUM
    # 例: 今日が20日で誕生日が5日なら単純な引き算で15日
    passed_day = TODAY_DAT_NUM - BIRTH_DAY_NUM
  else
    # 例: 今日が10日で誕生日が20日なら前月の最終日を確認しながら計算する
    prev_month_date = TODAY.prev_month
    prev_max_date = Date.new(prev_month_date.year, prev_month_date.month, -1).day
    passed_day = (prev_max_date - BIRTH_DAY_NUM) + TODAY_DAT_NUM
    # このケースだと、たとえば今が5月で誕生月が4月の場合、1月も経っていないので-1する
    passed_month -= 1
  end

  passed_year = TODAY_YEAR - BIRTH_YEAR
  # 今年誕生日を迎えているか？を確認し、迎えていない場合は-1する
  passed_year -= 1 if TODAY < Date.new(TODAY_YEAR, BIRTH_MONTH, BIRTH_DAY_NUM)
  "#{passed_year}才#{passed_month}ヶ月#{passed_day}日"
end

BIRTH_DATE = Date.parse(ENV['BIRTH_DAY'])
BIRTH_YEAR, BIRTH_MONTH, BIRTH_DAY_NUM = [BIRTH_DATE.year, BIRTH_DATE.month, BIRTH_DATE.day]
TODAY = Date.today
TODAY_YEAR, TODAY_MONTH, TODAY_DAT_NUM = [TODAY.year, TODAY.month, TODAY.day]

message = {
  type: 'text',
  text: calculate_age_in_weeks_and_days
}

# 友達全員にメッセージを送信
client.broadcast(message)
