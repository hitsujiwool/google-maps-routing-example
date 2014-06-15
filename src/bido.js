
function isPromise(obj) {
  return typeof obj.then === 'function';
}

function call(func, ctx, cb) {
  var res = func.call(null, ctx);
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
      call(redo, {}, function() {
        undos.push({ redo: redo, undo: undo, ctx: {} });
        f.onStack && f.onStack();
      });
    };
  };

  f.hasUndo = function() {
    return undos.length > 0;
  };

  f.undo = function() {
    var command = undos.pop();
    call(command.undo, command.ctx, function() {
      redos.push(command);
      f.onUndo && f.onUndo();
    });
  };

  f.hasRedo = function() {
    return redos.length > 0;
  };

  f.redo = function() {
    var command = redos.pop();
    call(command.redo, command.ctx, function() {
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
