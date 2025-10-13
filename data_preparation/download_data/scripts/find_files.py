import requests
from bs4 import BeautifulSoup

url = "https://dados.cvm.gov.br/dados/FI/"
resp = requests.get(url)
soup = BeautifulSoup(resp.text, "html.parser")

for link in soup.find_all('a'):
    href = link.get('href')
    if href and (href.endswith('.csv') or href.endswith('.zip')):
        print(href)