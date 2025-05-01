import openrouteservice

coords = ((-76.7671435,18.0102075),(-76.7671435,18.0102075),(-76.7476513,18.0064046),(-76.7493829,18.0057836))

client = openrouteservice.Client(base_url='http://localhost:8080/ors') # Specify your personal API key
routes = client.directions(coords,optimize_waypoints=True)


for item in routes['routes'][0]['segments']:
    print(item,end="\n\n")