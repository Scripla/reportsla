module ReportsHelper
  def report_card(title, options = {}, &block)
    options[:style] ||= ''
    options[:class] ||= ''
    title ||=  ''
    to_return = '<div class="card ' + options[:class] + '">'
    to_return += "<div class='card-header form-label text-dark #{options[:header_class]}'>"
    to_return += title
    to_return += '</div>'
    to_return += '<div class="card-body" style="' + options[:style] + '">'
    to_return += with_output_buffer(&block)
    to_return += '</div>'
    to_return += '</div>'
    to_return.html_safe
  end

  def report_link_to(report, title, url)
    link_to title, url if can? :show, report
  end

  def report_align(format)
    return 'right' if %w[money integer].include? format.downcase
    return 'left' if format.downcase == 'string'

    return 'center'
  end

end
