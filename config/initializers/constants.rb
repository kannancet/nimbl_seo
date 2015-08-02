GOOGLE_SEARCH_URL = 'http://www.google.com'
PAGE_RIGHT_HAND_SIDE1 = "//td[@id='rhs_block']/ol/li[@class='ads-ad']/h3/a"
PAGE_RIGHT_HAND_SIDE2 = "//td[@id='rhs_block']/ol/li[@class='ads-ad _kug']/h3/a"

AD_BLOCK_ANCHOR_TAG = "//li[@class='ads-ad']/h3/a[@style='display:none']"
PAGE_TOP_HAND_SIDE = "//div[@id='tads']/ol/li[@class='ads-ad']/h3/a[@style='display:none']"
PAGE_RESULT_SIDE = "//div[@id='ires']"
RESULT_BLOCK_ANCHOR_TAG = "//div[@class='rc']/h3/a"
TOTAL_RESULT_TEXT_BLOCK = "//div[@id='resultStats']"


QUERY_BANK = [{type: 1, method: "url_contains_adword_count"},
						  {type: 2, method: "count_of_url_in_seo"}]


OPERATION_IMPORT_LOG = "#{Rails.root}/public/operation_import.log"
