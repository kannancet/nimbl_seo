namespace :seed do
  
  desc "Process to import operations from CSV."
  task :default_page => :environment do
    
    begin
      path = "#{Rails.root}/public/data/sample.html"
      file = File.open(path).read

      keyword = GoogleKeyword.find_or_create_by(name: "website")
      keyword.google_search_page.destroy if keyword.google_search_page

      page = Nokogiri::HTML(file)
      keyword.create_google_search_page(page)
      keyword.save_adword_urls(page)
      keyword.save_nonadword_urls(page)
    rescue Exception => e
      puts e.message
    end

  end
  
end