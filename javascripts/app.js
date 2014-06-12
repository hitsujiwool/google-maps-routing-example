(function() {
  var routeEditor = require('route-editor');
  document.addEventListener('DOMContentLoaded', function() {
    var opts = {
      zoom: 16,
      center: new google.maps.LatLng(35.663424, 139.705023)
    };
    var map = new google.maps.Map(document.getElementById('map'), opts);
    var data = routeEditor(map);
    var trail = data.trail;
    trail
      .on('add', function() {
        document.querySelector('.distance').innerText = formatAsKm(trail.calcDistance());
      })
      .on('update', function() {
        document.querySelector('.distance').innerText = formatAsKm(trail.calcDistance());
      });
  });

  function formatAsKm(n) {
    return pad((Math.round(n / 10) * 10 / 1000), 2).toString();
  }

  function pad(n, d) {
    var str = n.toString();
    var index = n.toString().indexOf('.');
    if (index > 0) {
      if (str.slice(index).length < d) {
        for (var i = 0, len = str.slice(index).length; i < d - len; i++) {
          str += '0';
        }
      }
    }
    return str;
  }

})();
