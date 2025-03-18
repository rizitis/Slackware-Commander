import json
import folium
import requests

# Input JSON file with mirror results
input_file = "/var/lib/captain-slack/mirror-db/mirrors_results.json"

# Load mirror data from JSON file
with open(input_file, "r") as file:
    data = json.load(file)

# Initialize a map
map_center = [20, 0]  # Approximate center of the world
mirror_map = folium.Map(location=map_center, zoom_start=2)

# Function to get geolocation from a hostname or URL
def get_geolocation(url):
    try:
        # Extract hostname from the URL
        hostname = url.split("//")[-1].split("/")[0]
        # Use a geolocation API (replace with your chosen API)
        response = requests.get(f"https://geolocation-db.com/json/{hostname}&position=true").json()
        if response.get("latitude") and response.get("longitude"):
            return response["latitude"], response["longitude"]
    except Exception as e:
        print(f"Error fetching location for {url}: {e}")
    return None

# Add markers for each mirror
for mirror in data["mirrors"]:
    url = mirror["url"]
    latency = mirror["latency"]
    location = get_geolocation(url)

    if location:
        latitude, longitude = location
        folium.Marker(
            location=[latitude, longitude],
            popup=f"URL: {url}<br>Latency: {latency} ms",
            icon=folium.Icon(color="red")
        ).add_to(mirror_map)
    else:
        print(f"Could not determine location for {url}")

# Save the map to an HTML file
output_html = "/tmp/mirrors_map.html"
mirror_map.save(output_html)

print(f"Map with mirrors saved to {output_html}. Open this file in a browser to view the map.")
