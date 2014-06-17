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
    var stack = data.stack;
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
    
    stack.onStack = function() {
      console.log('stack');
      document.querySelector('.js-undo').classList.remove('state-disabled');      
      document.querySelector('.js-redo').classList.add('state-disabled');
    };

    stack.onUndo = function() {
      var el = document.querySelector('.js-undo');
      stack.hasUndo() ? el.classList.remove('state-disabled') : el.classList.add('state-disabled');
      document.querySelector('.js-redo').classList.remove('state-disabled');
    };

    stack.onRedo = function() {
      var el = document.querySelector('.js-redo');
      stack.hasRedo() ? el.classList.remove('state-disabled') : el.classList.add('state-disabled');
      document.querySelector('.js-undo').classList.remove('state-disabled');
    };

    document.querySelector('.js-undo').addEventListener('click', function() {
      if (this.classList.contains('state-disabled')) return;
      this.classList.add('state-disabled');
      stack.undo();
    });
    document.querySelector('.js-redo').addEventListener('click', function() {
      if (this.classList.contains('state-disabled')) return;
      this.classList.add('state-disabled');
      stack.redo();
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
