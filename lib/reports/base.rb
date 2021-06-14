# @Author: Robert D. Cotey II <coteyr@coteyr.net>
# @Date:   2014-10-20 11:30:10
# @Last Modified by:   Robert D. Cotey II <coteyr@coteyr.net>
# @Last Modified time: 2021-02-04 10:27:44

# A module to hold all report definitions
module Reports
  include Registerable
  # extend self

  # Returns All registered reports
  def self.reports
    regestered_classes(:reports)
  end
  # Returns reports in a category
  def self.by_category(category)
    result = []
    for report in Reportsla.configuration.registers[:reports]
      result << report if report[:options][:category] == category
    end
    result
  end
  # Base class for all reports, has useful methods for writing report definitions.
  class Base
    attr_accessor :start_date
    attr_accessor :end_date
    attr_accessor :current_user


    def initialize(current_user, start_date=Date.today - 31.days, end_date=Date.today, options={})
      @start_date = start_date
      @end_date = end_date + 1.days
      @current_user = current_user
      @options = options
      @params = options[:params]
    end

    # The title of the report
    def title
      "New Report"
    end
    # Headers to use as an array, Headers must match data columns
    def headers
      [['Data']]
    end
    # Formats to use for data columns. Currently supports 'String', 'Number', and 'Percentage'
    def formats
      ['String']
    end
    # The actual data in the report
    def data
      @data ||= generate_data
      return @data
    end
    # Generates the actually data in an Array or Arrays
    def generate_data
      [['one']]
    end
    # Abstract method to build a chart based on +data+
    def chart
      result = {}
      settings = {}
      height = 0
      {title: self.title, type: 'horizontal-bar', height: "#{height}px", data: result.to_json, options: settings.to_json}
    end
    # A simple method that calls and returns all the data to render a report
    def get
      return self.title, self.headers, self.formats, self.data, self.chart
    end
    # Do we need  dates? Overload if we do not.
    def needs_dates?
      true
    end
    # registers the report
    def self.register_report(klass, url, symbol, title)
      Reports.register_class(klass, :reports, {url: url, category: self.category, symbol: symbol, name: title})
    end
private
    def line_chart(title, label_column, data_columns=[], series_labels=[])
      result = []
      y = 0
      for column in data_columns
        points = []
        ticks = []
        height = 53
        x = 0
        for row in data do
          x = x + 1
          points << [x, row[column]]
          ticks <<   [x, row[label_column]]
          height = height + 20
        end
        result << {
          label: series_labels[y],
          lines: {
            horizontal: false,
            show: true,
            order: 1
          },
          data: points
        }
        y = y + 1
      end
      settings = {
        series: {
          lines: {
            fill: false,
            fillColor: { colors: [ { opacity: 0.9 }, { opacity: 1 } ] },
            lineWidth: 2
          }
        },
        xaxis: {
          ticks: ticks,
          rotateTicks: 135
        }
      }
      return {title: title, type: 'line', height: "#{height}px", data: result.to_json, options: settings.to_json}
    end

    def horizontal_bar_chart(title, label_column, data_columns=[], series_labels=[])
      return false if data.length >= 60
      result = []
      labels = []
      for row in data
        labels << row[label_column]
        for column in data_columns
          result << row[column]
        end
      end

      chart = {
        labels: labels,
        datasets: [{
          label: title,
          backgroundColor: '#aa0000',
          borderColor: '#ff0000',
          data: result
        }]
      }



      return {title: title, type: 'horizontalBar', data: chart.to_json}
    end
    def pie_chart(title, label_column, data_columns=[], series_labels=[])
      return false if data.length >= 20
      result = []
      labels = []
      colors = []
      for row in data do
        labels << row[label_column].gsub("'", '')
        colors << "##{"%06x" % (rand * 0xffffff)}"
        for column in data_columns
          result << row[column]
        end
      end
      chart = {
        datasets: [{
          label: title,
          data: result,
          backgroundColor: colors

        }],

        labels: labels

      }

      return {title: title, type: 'pie', data: chart.to_json}
    end
  end
end
