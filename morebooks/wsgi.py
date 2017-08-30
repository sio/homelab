import os.path
from hlc.launcher import wsgi_app

application = wsgi_app(os.path.join(os.path.dirname(__file__), "hlc_config.json"))
