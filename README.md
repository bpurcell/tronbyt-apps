# tronbyt-apps

Custom apps for a self-hosted [Tronbyt](https://github.com/tronbyt/server) display.

All three read a single `status.json` served from the NAS, rather than calling
SolarEdge or Jellyfin directly. That keeps API keys off the display, and keeps
SolarEdge's ~300 requests/day limit comfortably out of reach — a collector
script on the NAS polls every 15 minutes and writes the JSON.

| App | Shows |
| --- | --- |
| `nasstorage` | Used / total space on the media array, with a fill bar |
| `randommovie` | A random film from the Jellyfin library |
| `solarnow` | Current solar output and today's generation |

Point Tronbyt at this repo under **Admin Settings → Custom app repo**, then
click **Refresh**.
