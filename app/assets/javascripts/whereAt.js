/* myLoc.js */

var watchId = null;
var map = null;
var ourCoords =  {
	latitude: 47.624851,
	longitude: -122.52099
};
var prevCoords = null;
var markersArray = [];

window.onload = getMyLocation;

function getMyLocation() {
	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(
			displayLocation, 
			displayError,
			{enableHighAccuracy: true, timeout:9000});
	}
	else {
		alert("Oops, no geolocation support");
	}
}

function getCoordinates(address, callback) {
	var contentString = 'test';

	var infowindow = new google.maps.InfoWindow({
	    content: contentString
	});

	var geocoder = new google.maps.Geocoder();

	geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        callback(results[0].geometry.location);
        var marker = new google.maps.Marker({
            map: map,
            animation: google.maps.Animation.DROP,
            position: results[0].geometry.location
        });
        markersArray.push(marker);
        google.maps.event.addListener(marker, 'click', function() {
  			infowindow.open(map,marker);
  		});
      } else {
			alert("Geocode was not successful for the following reason: " + status);
      }
    });
}

function clearMarkers() {
  if (markersArray) {
    for (i in markersArray) {
      markersArray[i].setMap(null);
    }
  }
}

function displayLocation(position) {
	var latitude = position.coords.latitude;
	var longitude = position.coords.longitude;

	var div = document.getElementById("location");
	
	var latLng = new google.maps.LatLng(latitude, longitude);

	geocoder = new google.maps.Geocoder();
	geocoder.geocode({'latLng': latLng}, function(results, status) {
	     if (status == google.maps.GeocoderStatus.OK) {
	       if (results[0]) {
	         	div.innerHTML = results[0]['formatted_address'];
	       }
	     } else {
	       alert("Geocoder failed due to: " + status);
	     }
	   });

	if (map == null) {
		showMap(position.coords);
		prevCoords = position.coords;
	}
	else {
		var meters = computeDistance(position.coords, prevCoords) * 1000;
		if (meters > 20) {
			scrollMapToPosition(position.coords);
			prevCoords = position.coords;
		}
	}
}


// function codeLatLng(var input) {
//     var latlngStr = input.split(",",2);
//     var lat = parseFloat(latlngStr[0]);
//     var lng = parseFloat(latlngStr[1]);
//     var latlng = new google.maps.LatLng(lat, lng);
//     geocoder.geocode({'latLng': latlng}, function(results, status) {
//       if (status == google.maps.GeocoderStatus.OK) {
//         if (results[1]) {
//           map.setZoom(11);
//           marker = new google.maps.Marker({
//               position: latlng,
//               map: map
//           });
//           infowindow.setContent(results[1].formatted_address);
//           infowindow.open(map, marker);
//         }
//       } else {
//         alert("Geocoder failed due to: " + status);
//       }
//     });
//   }


// --------------------- Ready Bake ------------------
//
// Uses the Spherical Law of Cosines to find the distance
// between two lat/long points
//
function computeDistance(startCoords, destCoords) {
	var startLatRads = degreesToRadians(startCoords.latitude);
	var startLongRads = degreesToRadians(startCoords.longitude);
	var destLatRads = degreesToRadians(destCoords.latitude);
	var destLongRads = degreesToRadians(destCoords.longitude);

	var Radius = 6371; // radius of the Earth in km
	var distance = Math.acos(Math.sin(startLatRads) * Math.sin(destLatRads) + 
					Math.cos(startLatRads) * Math.cos(destLatRads) *
					Math.cos(startLongRads - destLongRads)) * Radius;

	return distance;
}
// function computerDistance(startCoords, destCoords) {
// 	var origin1 = new google.maps.LatLng(55.930385, -3.118425);
// 	var origin2 = "Greenwich, England";
// 	var destinationA = "Stockholm, Sweden";
// 	var destinationB = new google.maps.LatLng(50.087692, 14.421150);

// var service = new google.maps.DistanceMatrixService();
// service.getDistanceMatrix(
//   {
//     origins: [origin1, origin2],
//     destinations: [destinationA, destinationB],
//     travelMode: google.maps.TravelMode.DRIVING,
//     avoidHighways: false,
//     avoidTolls: false
//   }, callback);

// function callback(response, status) {
//   // See Parsing the Results for
//   // the basics of a callback function.
// }
// }

function degreesToRadians(degrees) {
	radians = (degrees * Math.PI)/180;
	return radians;
}

// ------------------ End Ready Bake -----------------

function showMap(coords) {
	var googleLatAndLong = new google.maps.LatLng(coords.latitude, 
												  coords.longitude);

	var mapOptions = {
		zoom: 13,
		center: googleLatAndLong,
		mapTypeId: google.maps.MapTypeId.ROADMAP
	};

	var mapDiv = document.getElementById("map_canvas");

	map = new google.maps.Map(mapDiv, mapOptions);

	// add the user marker
	var title = "Your Location";
	var content = "You are here: " + coords.latitude + ", " + coords.longitude;
	addMarker(map, googleLatAndLong, title, content);
}

function addMarker(map, latlong, title, content) {
	var markerOptions = {
		position: latlong,
		map: map,
		title: title,
		clickable: true
	};
	var marker = new google.maps.Marker(markerOptions);

	var infoWindowOptions = {
		content: 'This is just a test',
		position: latlong
	};

	var infoWindow = new google.maps.InfoWindow(infoWindowOptions);

	google.maps.event.addListener(marker, 'click', function() {
		infoWindow.open(map);
	});
}


function displayError(error) {
	var errorTypes = {
		0: "Unknown error",
		1: "Permission denied",
		2: "Position is not available",
		3: "Request timeout"
	};
	var errorMessage = errorTypes[error.code];
	if (error.code == 0 || error.code == 2) {
		errorMessage = errorMessage + " " + error.message;
	}
	var div = document.getElementById("location");
	div.innerHTML = errorMessage;
}

//
// Code to watch the user's location
//
function watchLocation() {
	watchId = navigator.geolocation.watchPosition(
					displayLocation, 
					displayError,
					{enableHighAccuracy: true, timeout:3000});
}

function scrollMapToPosition(coords) {
	var latitude = coords.latitude;
	var longitude = coords.longitude;

	var latlong = new google.maps.LatLng(latitude, longitude);
	map.panTo(latlong);

	// add the new marker
	addMarker(map, latlong, "Your new location", "You moved to: " + 
								latitude + ", " + longitude);
}

function clearWatch() {
	if (watchId) {
		navigator.geolocation.clearWatch(watchId);
		watchId = null;
	}
}


