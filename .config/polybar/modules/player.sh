#!/usr/bin/env python3
import dbus
import time
from unicodedata import east_asian_width

# --- Configuration ---
MAX_LEN = 20        # Length of visible text
UPDATE_DELAY = 0.3  # Scroll speed
FONT_INDEX = 1

ICONS = {
    "spotify": '  ',
    "default": '  '
}
# ---------------------

def get_visual_len(text):
    return sum(2 if east_asian_width(c) in 'WF' else 1 for c in text)

def truncate_visual(text, length):
    current_len = 0
    res = ""
    for char in text:
        width = 2 if east_asian_width(char) in 'WF' else 1
        if current_len + width <= length:
            res += char
            current_len += width
        else:
            break
    return res + " " * (length - current_len)

class MusicPlayer:
    def __init__(self):
        self.bus = dbus.SessionBus()
        self.scroll_pos = 0
        self.last_metadata = ""

    def get_active_player(self):
        # List names once per loop instead of deep-probing every time
        players = [n for n in self.bus.list_names() if n.startswith('org.mpris.MediaPlayer2.')]
        return players[0] if players else None

    def get_info(self, player_name):
        obj = self.bus.get_object(player_name, '/org/mpris/MediaPlayer2')
        iface = dbus.Interface(obj, 'org.freedesktop.DBus.Properties')
        
        metadata = iface.Get('org.mpris.MediaPlayer2.Player', 'Metadata')
        status = iface.Get('org.mpris.MediaPlayer2.Player', 'PlaybackStatus')
        
        artist = metadata.get('xesam:artist', ['Unknown'])[0]
        title = metadata.get('xesam:title', 'Unknown')
        
        icon = ICONS["default"]
        for key in ICONS:
            if key in player_name.lower():
                icon = ICONS[key]
                break
        
        return f"{artist} - {title}", icon, status

    def run(self):
        while True:
            try:
                name = self.get_active_player()
                if not name:
                    print("", flush=True) # Hide if no player
                    time.sleep(2)
                    continue

                full_text, icon, status = self.get_info(name)
                
                # Reset scroll if song changes
                if full_text != self.last_metadata:
                    self.scroll_pos = 0
                    self.last_metadata = full_text

                # Handle Scrolling logic
                if get_visual_len(full_text) > MAX_LEN:
                    # Add padding for a smooth loop
                    display_text = full_text + " | "
                    # Use modulo to cycle the string
                    pos = self.scroll_pos % len(display_text)
                    shifted = display_text[pos:] + display_text[:pos]
                    out = truncate_visual(shifted, MAX_LEN)
                    if status == "Playing":
                        self.scroll_pos += 1
                else:
                    out = truncate_visual(full_text, MAX_LEN)

                print(f"{icon} %{{T{FONT_INDEX}}}{out}%{{T-}}", flush=True)

            except Exception:
                print("", flush=True)
            
            time.sleep(UPDATE_DELAY)

if __name__ == "__main__":
    MusicPlayer().run()
