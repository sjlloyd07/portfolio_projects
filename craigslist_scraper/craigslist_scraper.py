#! python3
#! craigslist_scraper.py
# narrow scope craigslist current listings scraper

# chicago.craigslist.org
# searches for all listings in car and truck category and writes results to .csv file 
# returns very dirty data
# no cleaning operations performed



import requests, os, bs4, csv, json, time
from selenium import webdriver
from selenium.webdriver.firefox.options import Options

# predetermined craigslist search category (cars and trucks)
url = "https://chicago.craigslist.org/search/cta#search=1~gallery~"


# prints string character 1 at a time
def print_this(this):
    for l in this:
        print(l,end='',flush=True)
        time.sleep(.1)
    print()

loading = "\nPlease wait while results load...\n"

print_this(loading)



# custom TestBot firefox profile has ghostery and ublockOrigin
profile_path = r'C:\Users\steve\AppData\Roaming\Mozilla\Firefox\Profiles\snws8jty.TestBot'

# create selenium webdriver options instance
options = Options()
# set webdriver options to custom profile
options.set_preference('profile', profile_path)
#open new browser using custom firefox profile
driver = webdriver.Firefox(options=options)


#new list for listing results
listings = []

# page counter
url_pg = 0

# loop loads search results pages and saves to list
while True:
    # navigate to next page
    url = url + str(url_pg) 

    #navigate to url
    driver.get(url)
    time.sleep(.1) #allow page time to load

    # search for page element: total number of results
    try:
        total_results_elem = driver.find_elements('css selector', '.cl-page-number') # element
    except:
        print('Could not find element. Trying again...')
        continue

    # convert total_results_elem into integers
    elem_split = total_results_elem[0].text.split() #total_results_elem split
    results_1 = int(''.join(elem_split[0].split(','))) #results blank 1, remove comma, convert to int
    results_2 = int(''.join(elem_split[2].split(','))) #results blank 2, remove comma, convert to int
    results_tot = int(''.join(elem_split[-1].split(',')))  # total results as str


    #  search for page elements: list of results for each page
    try:
        web_elem_lst = driver.find_elements('css selector', '#search-results-page-1 > ol > li')
    except:
        print('Could not find element. Trying again...')
        continue
        
    # add every result title to listings
    for i in range(len(web_elem_lst)):
        listings.append(web_elem_lst[i].get_attribute('title'))


    # print number of results for each page
    print(f'Adding results {results_1} thru {results_2} of {results_tot}')

    # check if results page is final results page, break loop if it is
    if results_2 < results_tot:
        url_pg += 1 #add page # to counter
        url_split = url.split('~')
        url_split[-1] = ''
        url = '~'.join(url_split) #create new page url to navigate to
        continue
    else:
        break


print_this('\nTotal listings added: ')
print(len(listings))
print()


# TODO: write results to csv file

# get current time, format for filename
now = time.strftime("%Y-%m-%d %H:%M")
now = now.replace('-','_').replace(' ','_').replace(':','_') + '.csv'

# assign new filepath in save folder
save_folder = 'C:\\Users\\steve\\python\\projects\\craigslist'
filepath = save_folder + '\\' + now

# write list items to csv file
with open(filepath, 'w',newline='',encoding='utf-8') as csvObj:
    csvWriter = csv.DictWriterwriter(csvObj)
    csvWriter.writerow(['listing'])
    for item in listings:
        csvWriter.writerow([item])


print_this('Results saved to file: ')
print(filepath)

