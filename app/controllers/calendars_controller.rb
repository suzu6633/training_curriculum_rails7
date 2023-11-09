class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays_num = Date.today.wday
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']
    current_wday = wdays[wdays_num]

    @todays_date = Date.today

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      todays_plans = []
      plans.each do |plan|
        todays_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      if wdays_num >= 7
        wdays_num -= 7
      end

      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: todays_plans, wday: wdays[wdays_num]}
      @week_days.push(days)

      wdays_num = (wdays_num + 1) % 7
    end
  end
end