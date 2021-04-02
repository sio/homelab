import re
import urllib.request


def fetch_html(url):
    '''Fetch raw HTML from URL'''
    response = urllib.request.urlopen(url)
    if response.status != 200:
        raise ValueError(f'HTTP {response.status}: {url}')
    return response.read().decode()


def find_latest_date(html):
    '''Find latest daily timestamp'''
    date_regex = re.compile(r'\d{8}-\d+')
    timestamps = date_regex.findall(html)
    if not timestamps:
        raise ValueError(f'provided text does not match the regex: {date_regex}')
    return sorted(timestamps)[-1]


if __name__ == '__main__':
    print(find_latest_date(fetch_html('http://cdimage.debian.org/cdimage/cloud/buster/daily/')))
