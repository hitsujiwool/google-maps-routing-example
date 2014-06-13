(function() {
  var routeEditor = require('route-editor');
  document.addEventListener('DOMContentLoaded', function() {
    var opts = {
      zoom: 16,
      center: new google.maps.LatLng(35.663424, 139.705023),
      clickableLabels: false 
    };
    var map = new google.maps.Map(document.getElementById('map'), opts);
    var data = routeEditor(map);
    var trail = data.trail;
    var bido = data.bido;
    trail
      .on('add', function() {
        document.querySelector('.distance').innerText = formatAsKm(trail.calcDistance());
      })
      .on('update', function() {
        document.querySelector('.distance').innerText = formatAsKm(trail.calcDistance());
      })
      .on('remove', function() {
        document.querySelector('.distance').innerText = formatAsKm(trail.calcDistance());
      });
    
    bido.onStack = function() {
      document.querySelector('.js-undo').classList.remove('state-disabled');      
      document.querySelector('.js-redo').classList.add('state-disabled');
    };

    bido.onUndo = function() {
      var el = document.querySelector('.js-undo');
      bido.hasUndo() ? el.classList.remove('state-disabled') : el.classList.add('state-disabled');
      document.querySelector('.js-redo').classList.remove('state-disabled');
    };

    bido.onRedo = function() {
      var el = document.querySelector('.js-redo');
      bido.hasRedo() ? el.classList.remove('state-disabled') : el.classList.add('state-disabled');
      document.querySelector('.js-undo').classList.remove('state-disabled');
    };

    document.querySelector('.js-undo').addEventListener('click', function() {
      if (this.classList.contains('state-disabled')) return;
      bido.undo();
    });
    document.querySelector('.js-redo').addEventListener('click', function() {
      if (this.classList.contains('state-disabled')) return;
      bido.redo();
    });
  });

  function formatAsKm(n) {
    return pad((Math.round(n / 10) * 10 / 1000), 2).toString();
  }

  function pad(n, d) {
    var str = n.toString();
    var index = n.toString().indexOf('.');
    var len;
    if (index < 0) {
      str += '.';
      index = str.length - 1;
      console.log(index);
    }
    len = str.slice(index + 1).length;
    if (len < d) {
      for (var i = 0; i < d - len; i++) {
        str += '0';
      }
    }
    return str;
  }
})();
