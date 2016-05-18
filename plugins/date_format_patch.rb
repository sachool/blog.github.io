require 'octopress-date-format'
module Octopress
  module PageDate
    def self.hack_date(page)
      if page.data['date'] || page.respond_to?(:date)
	date = datetime(page.data['date'] || page.date)

	page.data['date_xml'] = date.xmlschema
	page.data['date_text'] = format_date(date)
	page.data['time_text'] = format_time(date)
	page.data['date_html'] = date_html(date, false)
	page.data['date_time_html'] = date_html(date)
      end

      # Legacy support
      if page.data['updated']
        page.data['date_updated'] = page.data['updated']
      end

      if page.data['date_updated']
        updated  = datetime(page.data['date_updated'])
        page.data['date_updated_xml']  = updated.xmlschema
        page.data['date_updated_text'] = format_date(updated)
        page.data['time_updated_text'] = format_time(updated)
        page.data['date_updated_html'] = date_updated_html(updated, false)
        page.data['date_time_updated_html'] = date_updated_html(updated)
      elsif page.data['date'] || page.respond_to?(:date)
        page.data['date_html'].sub!('entry-date','entry-date updated')
        page.data['date_time_html'].sub!('entry-date','entry-date updated')
      end

      page

    end
  end
end
