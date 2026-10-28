load("render.star", "render")
load("http.star", "http")

URL = "http://192.168.40.36:8091/status.json"
TTL = 300

def main(config):
    resp = http.get(URL, ttl_seconds = TTL)
    if resp.status_code != 200:
        return err("no data")

    d = resp.json().get("movie")
    if not d:
        return err("no movies")

    year = d.get("year")

    return render.Root(
        child = render.Column(
            expanded = True,
            main_align = "center",
            cross_align = "center",
            children = [
                render.Text("TONIGHT?", color = "#4e7a5e", font = "tom-thumb"),
                render.Box(height = 1),
                # Titles never fit in 64px, so scroll them.
                render.Marquee(
                    width = 64,
                    child = render.Text(d.get("title", "?"), color = "#ffffff"),
                ),
                render.Text(str(year) if year else "", color = "#7f8c86", font = "tom-thumb"),
            ],
        ),
    )

def err(msg):
    return render.Root(
        child = render.Box(
            child = render.Text(msg, color = "#7f8c86", font = "tom-thumb"),
        ),
    )
