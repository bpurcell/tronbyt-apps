load("render.star", "render")
load("http.star", "http")

URL = "http://192.168.40.36:8091/status.json"
TTL = 300

def main():
    resp = http.get(URL, ttl_seconds = TTL)
    if resp.status_code != 200:
        return err("no data")

    d = resp.json().get("storage")
    if not d:
        return err("no data")

    used = d.get("used_tb", 0)
    total = d.get("total_tb", 1)
    pct = d.get("pct", 0)

    # Bar turns amber past 70%, red past 85%.
    color = "#4e7a5e"
    if pct > 85:
        color = "#e05d44"
    elif pct > 70:
        color = "#c89a23"

    fill = int(60 * pct / 100)
    if fill < 1 and pct > 0:
        fill = 1

    return render.Root(
        child = render.Column(
            expanded = True,
            main_align = "center",
            cross_align = "center",
            children = [
                render.Text("NAS", color = "#7f8c86", font = "tom-thumb"),
                render.Text("%.1f/%.0fTB" % (used, total), color = "#ffffff"),
                render.Box(height = 2),
                render.Stack(children = [
                    render.Box(width = 60, height = 3, color = "#232826"),
                    render.Box(width = fill, height = 3, color = color),
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
