
DATE_FORMATS = [
				{format: /^\d{2}\/\d{2}\/\d{4}$/, type: '%m/%d/%Y'}, 
				{format: /^\d{4}-\d{2}-\d{2}$/, type: '%Y-%m-%d'}, 
				{format: /^\d{2}-\d{2}-\d{4}$/, type: '%d-%m-%Y'}
			   ]

OPERATION_IMPORT_LOG = "#{Rails.root}/log/operation_import.log"
CSV_TEMPLATE = "#{Rails.root}/public/download_csv_template.csv"
CSV_TEMPLATE_HEADER = ["company",
					   "invoice_num",
					   "invoice_date",
					   "operation_date",
					   "amount",
					   "reporter",
					   "notes",
					   "status",
					   "kind"]



GOOGLE_SEARCH_URL = 'https://www.google.co.in/#q='
PAGE_RIGHT_HAND_SIDE = "//div[@id='mbEnd']/ol/li[@class='ads-ad']/h3/a"
AD_BLOCK_ANCHOR_TAG = "//li[@class='ads-ad']/h3/a[@style='display:none']"
PAGE_TOP_HAND_SIDE = "//div[@id='tads']/ol/li[@class='ads-ad']/h3/a[@style='display:none']"
PAGE_RESULT_SIDE = "//div[@id='ires']"
RESULT_BLOCK_ANCHOR_TAG = "//div[@class='rc']/h3/a"
TOTAL_RESULT_TEXT_BLOCK = "//div[@id='resultStats']"


QUERY_BANK = [{type: 1, method: "url_contains_adword_count"},
						  {type: 2, method: "count_of_url_in_seo"}]