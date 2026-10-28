load("render.star", "render")
load("http.star", "http")

URL = "http://192.168.40.36:8091/status.json"
TTL = 300

# Tide heights fill the plot; the curve is the point, not the numbers.
RISING = "#3e6e8e"
FALLING = "#2f5d50"

def main(config):
    resp = http.get(URL, ttl_seconds = TTL)
    if resp.status_code != 200:
        return err("no data")

    d = resp.json().get("tide")
    if not d:
        return err("no tide")

    raw = d.get("points", [])
    if len(raw) < 2:
        return err("no tide")

    # JSON gives lists; Plot wants tuples of floats.
    points = [(float(p[0]), float(p[1])) for p in raw]

    color = RISING if d.get("rising") else FALLING
    now_x = int(d.get("now_x", 0))

    return render.Root(
        child = render.Column(
            expanded = True,
            children = [
                # Next event, which is what you actually want to know.
                render.Box(
                    height = 7,
                    child = render.Text(
                        d.get("next", ""),
                        color = "#ffffff",
                        font = "tom-thumb",
                    ),
                ),
                render.Stack(children = [
                    render.Plot(
                        data = points,
                        width = 64,
                        height = 25,
                        color = color,
                        fill = True,
                    ),
                    # Vertical marker for now, pushed across with padding
                    # since Stack children all anchor top-left.
                    render.Padding(
                        pad = (now_x, 0, 0, 0),
                        child = render.Box(
                            width = 1,
                            height = 25,
                            color = "#b8562a",
                        ),
                    ),
                ]),
            ],
        ),
    )

def err(msg):
    return render.Root(
        child = render.Box(
            child = render.Text(msg, color = "#7f8c86", font = "tom-thumb"),
        ),
    )
