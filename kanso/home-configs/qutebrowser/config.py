config.load_autoconfig(False)

# Gruvbox Theme
import gruvbox
gruvbox.setup(c)

# Default zoom
c.zoom.default = '100%'

# Disable Autosave Error
c.auto_save.interval = 0
c.auto_save.session = False

# Minimal UI
c.statusbar.padding = {'bottom': 1, 'left': 0, 'right': 0, 'top': 1}
c.tabs.padding = {'bottom': 2, 'left': 5, 'right': 5, 'top': 2}

# Adblock
c.content.blocking.enabled = True
c.content.blocking.method = "both"

# GPU optimisation
c.qt.args = [
    "enable-gpu-rasterization",
    "enable-native-gpu-memory-buffers",
    "num-raster-threads=4"
]

# Detele cookies when window's close
c.content.cookies.store = False
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')

# Header settings
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:145.0) Gecko/20100101 Firefox/145.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {qt_key}/{qt_version} {upstream_browser_key}/{upstream_browser_version_short} Safari/{webkit_version}', 'https://gitlab.gnome.org/*')

# Image settings
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')

# JavaScript settings
c.content.javascript.enabled = True
config.bind('tj', 'set -u {url:host} content.javascript.enabled true')
config.bind('tJ', 'set -u {url:host} content.javascript.enabled false')

# Local permission
config.set('content.local_content_can_access_remote_urls', True, 'file:///home/voktex/.local/share/qutebrowser/userscripts/*')
config.set('content.local_content_can_access_file_urls', False, 'file:///home/voktex/.local/share/qutebrowser/userscripts/*')

# Dark mode in default
c.colors.webpage.darkmode.policy.images = "never" 
c.colors.webpage.bg = "#282828"
