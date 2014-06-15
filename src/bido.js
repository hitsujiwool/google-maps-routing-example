
function isPromise(obj) {
  return typeof obj.then === 'function';
}

function call(func, cb) {
  var res = func.call();
  if (isPromise(res)) {
    res.then(cb);
  } else {
    cb && cb();
  }
  return res;
}

module.exports = function() {
  var undos = [];
  var redos = [];

  f.onStack = f.onUndo = f.onRedo = function() {};

  function f(redo, undo) {
    return function() {
      redos = [];
      call(redo, function() {
        undos.push({ redo: redo, undo: undo });
        f.onStack && f.onStack();
      });
    };
  };

  f.hasUndo = function() {
    return undos.length > 0;
  };

  f.undo = function() {
    var command = undos.pop();
    call(command.undo, function() {
      redos.push(command);
      f.onUndo && f.onUndo();
    });
  };

  f.hasRedo = function() {
    return redos.length > 0;
  };

  f.redo = function() {
    var command = redos.pop();
    call(command.redo, function() {
      undos.push(command);
      f.onRedo && f.onRedo();
    });
  };

  f.clear = function() {
    undos = [];
    redos = [];
  };

  return f;
};
