
module.exports = function() {
  var undos = [];
  var redos = [];

  function f(redo, undo) {
    undos.push({ redo: redo, undo: undo });    
    return function() {
      redos = [];
      redo();
      f.onStack && f.onStack();
    };
  };

  f.hasUndo = function() {
    return undos.length > 0;
  };

  f.undo = function() {
    var command = undos.pop();
    command.undo();
    redos.push(command);
    f.onUndo && f.onUndo();
  };

  f.hasRedo = function() {
    return redos.length > 0;
  };

  f.redo = function() {
    var command = redos.pop();
    command.redo();
    undos.push(command);
    f.onRedo && f.onRedo();
  };

  f.clear = function() {
    undos = [];
    redos = [];
  };

  return f;
};
