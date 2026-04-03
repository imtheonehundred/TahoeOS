#!/usr/bin/env python3
import gi

gi.require_version("Gtk", "4.0")
gi.require_version("Adw", "1")
gi.require_version("WebKit", "6.0")
from gi.repository import Gtk, Adw, WebKit, GLib

HELP_HTML = """
<!DOCTYPE html>
<html>
<head>
<style>
body {
    font-family: -apple-system, Inter, sans-serif;
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
    color: white;
    padding: 40px;
    margin: 0;
}
h1 { color: #667eea; }
h2 { color: #a0a0ff; margin-top: 30px; }
.card {
    background: rgba(255,255,255,0.1);
    border-radius: 12px;
    padding: 20px;
    margin: 20px 0;
}
a { color: #89b4fa; }
code {
    background: rgba(0,0,0,0.3);
    padding: 2px 6px;
    border-radius: 4px;
}
</style>
</head>
<body>
<h1>Welcome to TahoeOS</h1>
<p>TahoeOS brings the elegance of macOS to the Linux desktop with full gaming support.</p>

<div class="card">
<h2>Getting Started</h2>
<ul>
<li><strong>Finder</strong> - Browse your files</li>
<li><strong>System Preferences</strong> - Configure your system</li>
<li><strong>Software Update</strong> - Keep your system up to date</li>
<li><strong>Time Machine</strong> - Backup your files with Btrfs snapshots</li>
</ul>
</div>

<div class="card">
<h2>Keyboard Shortcuts</h2>
<ul>
<li><code>Super + Space</code> - Spotlight search</li>
<li><code>Super + Tab</code> - Switch applications</li>
<li><code>Super + D</code> - Show desktop</li>
<li><code>Super</code> - Overview / Mission Control</li>
</ul>
</div>

<div class="card">
<h2>Gaming</h2>
<p>TahoeOS comes with a complete gaming stack:</p>
<ul>
<li><strong>Steam</strong> - Play your Steam library</li>
<li><strong>Lutris</strong> - Play games from any platform</li>
<li><strong>Wine</strong> - Run Windows games and apps</li>
<li><strong>Gamescope</strong> - Optimized game compositor</li>
</ul>
<p>Double-click any <code>.exe</code> file to install Windows apps!</p>
</div>

<div class="card">
<h2>Support</h2>
<p>Visit <a href="https://github.com/tahoeos/tahoeos">github.com/tahoeos/tahoeos</a> for help and updates.</p>
</div>
</body>
</html>
"""


class HelpWindow(Adw.ApplicationWindow):
    def __init__(self, app):
        super().__init__(application=app, title="TahoeOS Help")
        self.set_default_size(800, 600)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        self.set_content(box)

        header = Adw.HeaderBar()
        box.append(header)

        webview = WebKit.WebView()
        webview.set_vexpand(True)
        webview.load_html(HELP_HTML, None)
        box.append(webview)


class HelpApp(Adw.Application):
    def __init__(self):
        super().__init__(application_id="org.tahoeos.help")

    def do_activate(self):
        win = HelpWindow(self)
        win.present()


if __name__ == "__main__":
    app = HelpApp()
    app.run()
