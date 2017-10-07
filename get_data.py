import requests, json
import pandas as pd

def get_json(alias, offset_num):
	"""
	Call DOL API for specified table and page offset
	Output: list of dictionaries
	"""
	url='https://data.dol.gov/get/SweatToilAll{}/format/json/limit/200/offset/{}'.format(alias, str(offset_num))
	headers = {'X-API-KEY': 'ef23e86d-0a3d-4769-b7dc-c2214e1987cf'}
	r = requests.get(url, headers=headers)
	return r.json()

alias_ls = ['Assessments', 'Conventions', 'Countries', 'CountryGoods', 'Enforcements', 
				'LegalStandards', 'Mechanisms', 'Statistics']

for alias in alias_ls:
	print("processing alias ", alias)
	r = []
	alias_results = []
	offset_num = -200
	# when results are available for alias for specified offset, result is a list of dictionaries
	# when no more results are available for alias for specified offset, result is dictionary showing error message
	while type(r) == list:
		alias_results.extend(r)		
		offset_num += 200 # results are paginated for every 200 results
		print("calling with offset ", offset_num)
		r = get_json(alias, offset_num)
		
	df = pd.DataFrame(alias_results)
	df.to_csv(alias+'.csv')