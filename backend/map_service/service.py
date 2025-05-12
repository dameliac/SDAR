import openrouteservice
from openrouteservice.directions import directions
from flask import *
import openrouteservice.directions
# from vehicle import getInfo
import vehicle

def getAutoComplete(client ,place:str):
    options = []
    data = openrouteservice.geocode.pelias_autocomplete(client,place,country= 'JAM')
    for i in data['features']:
        coords = i['geometry']['coordinates']
        name = i['properties']['name']
        options.append({'coords':coords,'name':name})
    return options

def getDistanceTime(client, start, end):
    coordinates = [start, end]
    data = openrouteservice.directions.directions(
        client,
        coordinates,
        profile='driving-car',
        format='geojson'
    )
    
    if data and 'features' in data and len(data['features']) > 0:
        route = data['features'][0]
        duration = route['properties']['segments'][0]['duration'] # seconds
        distance = route['properties']['segments'][0]['distance'] # meters
        return {
            "duration": duration,
            "distance": distance,
            "geometry": route['geometry'],
            "steps" : route['properties']['segments'][0]['steps']
        }
    # return None
    return None

client = openrouteservice.Client(key='5b3ce3597851110001cf62487acddaae03ca4effa06787faa38d46d7') # Specify your personal API key
# routes = directions(client, coords) # Now it shows you all arguments for .directions
# print(routes)


app = Flask(__name__)
@app.route('/autocomplete/<place>', methods=['GET'])
def autocomplete(place):
    client = openrouteservice.Client(key='5b3ce3597851110001cf62487acddaae03ca4effa06787faa38d46d7') # Specify your personal API key
    response = getAutoComplete(client,place)
    return {"status": "success", "data": response}

@app.route('/distance', methods=['POST'])
def getDistance():
    
    data = request.get_json()
    print(data)
    response = getDistanceTime(client,data['start'],data['end'])
    
    return {"data":response}
    
    # client = openrouteservice.Client(key='5b3ce3597851110001cf62487acddaae03ca4effa06787faa38d46d7')
    # result = getDistanceTime(client, start, end)
        
@app.route('/getvehicle/<make>/<model>/<year>')
def getVehicle(make , model , year):
    data = vehicle.getInfo(make,model,year)
    if data == False:
        return {"data":False}
    return {"data":data}

    
if __name__ == "__main__":
    app.run(port=9002)


