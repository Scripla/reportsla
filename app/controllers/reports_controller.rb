# frozen_string_literal: true

# @Author: Robert D. Cotey II <coteyr@coteyr.net>
# @Date:   2018-12-11 21:01:56
# @Last Modified by:   Robert D. Cotey II <coteyr@coteyr.net>
# @Last Modified time: 2021-02-23 12:25:20

# contains all the reports and report functions
class ReportsController < ApplicationController
  before_action :set_dates
  skip_authorization_check

  def index; end

  def show
    if can? :show, params[:report].to_sym
      report = "Reports::#{params[:report].camelize}".constantize.new(current_user, @start_date, @end_date, current_client, {params: params})
      @category = report.class.category
      @title, @headers, @formats, @results, @chart = report.get
      @page_title = "#{@category} - #{@title} #{report.needs_dates? ? "for #{l(@start_date)} to #{l(@end_date)}" : ''}"
      @needs_dates = report.needs_dates?
      @source_of_sale = @results.select { |result| result[0].is_a? Hash}
      respond_to do |format|
        format.html {
          render "#{params[:viewer]}_viewer"
        }
        format.csv {
          csv_string = CSV.generate do |csv|
            @results.each do |row|
              csv << row
            end
          end
          send_data csv_string
        }
      end
    else
      flash[:danger] = "You may not view this report (#{params[:report]})"
      redirect_to library_path
    end
  end

  private

  def set_dates
    @start_date = store_date(:start_date, Date.today - 30.days)
    @end_date = store_date(:end_date, Date.today)
  end

  def store_date(symbol, default)
    value = params[symbol] || session[symbol] || default
    return value if value.is_a? Date
    value = value.to_date
    session[symbol] = value
    value
  end
end
