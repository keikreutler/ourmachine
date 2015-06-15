L.mapbox.accessToken = 'pk.eyJ1IjoiZ2FtZXJhIiwiYSI6IjNlclVnZDAifQ.a8PjkEfE5i2aOShPawCy1A';
var map = L.mapbox.map('map', 'extinctly.f3ad5588', {
    zoomControl: true,
    minZoom: 2
}).setView([30, -25], 3);

map.scrollWheelZoom.disable();

/******************
CREATE LAYER GROUPS
******************/

var cubesats = new L.layerGroup();
var communications = new L.layerGroup();
var assorted_bright = new L.layerGroup();
var weather = new L.layerGroup();
var geodetic = new L.layerGroup();
var scientific = new L.layerGroup();
var engineering = new L.layerGroup();
var space_stations = new L.layerGroup();

var categories = {"CubeSats": cubesats, "Communications": communications, "Assorted Bright": assorted_bright, "Weather": weather, "Geodetic": geodetic, "Scientific": scientific, "Space Stations": space_stations, "Engineering": engineering}

/******************
LOAD MAP ICONS
******************/

var mapicon_US = L.mapbox.marker.icon({
        'marker-size': 'medium',
        'marker-symbol': 'star',
        'marker-color': '#fa0'
    })

var mapicon_CIS = L.icon({
    //iconUrl: '/images/map/volatility_sites.png',
    radius: 5,
    fillColor: "#89b3c0",
    color: "#FFF",
    weight: 1,
    opacity: 1,
    fillOpacity: 0.4
});



/******************
LOAD MAP DATA
******************/

/*** ASSIGN MARKER TYPES ***/

$.getJSON("/data/satellites.geojson", function(data) {
    L.geoJson(data, {
        pointToLayer: function(feature, latlng) {
        
            if (feature.properties.Owner === 'U.S.') {
                return L.circleMarker(latlng, {
                    radius: 5,
                    fillColor: "#88bb11",
                    color: "#FFF",
                    weight: 1,
                    opacity: 1,
                    fillOpacity: 0.8
                })
            ;            }
            else if (feature.properties.Owner === 'CIS') {
                return L.circleMarker(latlng, {
                    radius: 5,
                    fillColor: "#89b3c0",
                    color: "#FFF",
                    weight: 1,
                    opacity: 1,
                    fillOpacity: 0.8
                });
            } 
            else {
                return L.circleMarker(latlng, {
                    radius: 5,
                    fillColor: "#A3C990",
                    color: "#FFF",
                    weight: 1,
                    opacity: 1,
                    fillOpacity: 0.8
                });
            }
        },
        onEachFeature: createPopUps
        }).on('mouseover', function(e) {
            e.layer.openPopup();
        });
    });

function createPopUps(feature, featureLayer) {
    featureLayer.bindPopup('<h1>' + feature.properties.Name + '</h1><p>' + feature.properties.Category + '</p><h5>Owner: ' + feature.properties.Owner + '</h5>');
    categories[feature.properties.Category].addLayer(featureLayer);
}

cubesats.addTo(map);
communications.addTo(map);
assorted_bright.addTo(map);
weather.addTo(map);
geodetic.addTo(map);
scientific.addTo(map);
engineering.addTo(map);
space_stations.addTo(map);

L.control.layers(null, categories, {collapsed: false}).addTo(map);