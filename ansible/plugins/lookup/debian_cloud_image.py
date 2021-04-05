import platform
import re
import urllib.request


def get_debian_cloud_image(release, image='generic', arch=None):
    '''Return information about latest Debian Cloud image matching the provided parameters'''
    directory = f'https://cdimage.debian.org/cdimage/cloud/{release}/daily/'
    timestamp = get_latest_timestamp(directory)
    return get_image_details(f'{directory}{timestamp}', image, timestamp)


def fetch_html(url):
    '''Fetch raw HTML from URL'''
    response = urllib.request.urlopen(url)
    if response.status != 200:
        raise ValueError(f'HTTP {response.status}: {url}')
    return response.read().decode()


def get_latest_timestamp(url):
    '''Find latest daily timestamp for Debian Cloud image on HTML page'''
    html = fetch_html(url)
    date_regex = re.compile(r'\d{8}-\d+')
    timestamps = date_regex.findall(html)
    if not timestamps:
        raise ValueError(f'provided text does not match the regex: {date_regex}')
    return sorted(timestamps)[-1]


def get_image_details(url, image, timestamp, arch=None, filetype='qcow2'):
    '''Get Debian cloud image URLs for the given timestamp'''
    if not arch:
        arch = platform.machine().lower()
    html = fetch_html(url)

    def single_match(regex):
        '''Query regex for a single match against fetched HTML'''
        matches = set(regex.findall(html))
        if not matches:
            raise ValueError(f'pattern ({regex.pattern}) was not found on page: {url}')
        elif len(matches) != 1:
            raise ValueError(f'pattern ({regex.pattern}) appears multiple times on page: {url}\n{matches}')
        return matches.pop()

    image_regex = re.compile(r'a href="(debian-\d+-{image}-{arch}-daily-{timestamp}\.{filetype})"'.format(
        arch=arch,
        filetype=filetype,
        image=image,
        timestamp=timestamp,
    ))
    image_name = single_match(image_regex)

    checksum_regex = re.compile(r'a href="(SHA\d+SUMS)"')
    checksum_name = single_match(checksum_regex)

    return dict(
        image=f'{url}/{image_name}',
        checksum=f'{url}/{checksum_name}',
        timestamp=timestamp,
    )


if __name__ == '__main__':
    print(get_debian_cloud_image('buster'))
