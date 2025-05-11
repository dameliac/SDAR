import requests
import xml.etree.ElementTree as ET

year = 2012
make = "Honda"
model = "Fit"

# Step 1: Get vehicle options and IDs
options_url = f"https://www.fueleconomy.gov/ws/rest/vehicle/menu/options?year={year}&make={make}&model={model}"
response = requests.get(options_url)

if response.status_code == 200:
    root = ET.fromstring(response.content)
    for option in root.findall('menuItem'):
        option_name = option.find('text').text
        vehicle_id = option.find('value').text
        print(f"Option: {option_name} | Vehicle ID: {vehicle_id}")

        # Step 2: Get detailed vehicle data for each vehicle ID
        vehicle_url = f"https://www.fueleconomy.gov/ws/rest/vehicle/{vehicle_id}"
        vehicle_resp = requests.get(vehicle_url)
        if vehicle_resp.status_code == 200:
            vehicle_root = ET.fromstring(vehicle_resp.content)

            # Extract CO2 emissions (grams per mile)
            co2 = vehicle_root.findtext('co2TailpipeGpm')

            # Extract MPG values
            city_mpg = vehicle_root.findtext('city08')
            highway_mpg = vehicle_root.findtext('highway08')
            combined_mpg = vehicle_root.findtext('comb08')

            print(f"  CO2 Emissions (g/mi): {co2}")
            print(f"  City MPG: {city_mpg}")
            print(f"  Highway MPG: {highway_mpg}")
            print(f"  Combined MPG: {combined_mpg}")
        else:
            print("  Failed to retrieve vehicle details")
else:
    print("Failed to retrieve vehicle options")
