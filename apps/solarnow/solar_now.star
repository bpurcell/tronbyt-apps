load("render.star", "render")
load("http.star", "http")

URL = "http://192.168.40.36:8091/status.json"
TTL = 300

def main(config):
    resp = http.get(URL, ttl_seconds = TTL)
    if resp.status_code != 200:
        return err("no data")

    d = resp.json().get("solar")
    if d == None:
        return err("no data")

    watts = d.get("watts", 0)

    # Grey it out overnight rather than showing a bright zero.
    color = "#e3bc5a" if watts > 100 else "#555b57"

    return render.Root(
        child = render.Column(
            expanded = True,
            main_align = "center",
            cross_align = "center",
            children = [
                render.Text(d.get("now", "?"), color = color, font = "6x13"),
                render.Text(d.get("today", ""), color = "#7f8c86", font = "tom-thumb"),
            ],
        ),
    )

def err(msg):
    return render.Root(
        child = render.Box(
            child = render.Text(msg, color = "#7f8c86", font = "tom-thumb"),
        ),
    )
