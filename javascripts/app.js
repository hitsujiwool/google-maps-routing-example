(function() {
  var routeEditor = require('route-editor');
  document.addEventListener('DOMContentLoaded', function() {
    var opts = {
      zoom: 16,
      center: new google.maps.LatLng(35.663424, 139.705023)
    };
    var map = new google.maps.Map(document.getElementById('map'), opts);
    routeEditor(map);
  });
})();
