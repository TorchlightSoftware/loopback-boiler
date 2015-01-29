if (!(function f() {}).name) {
  Object.defineProperty(Function.prototype, 'name', {
    get: function() {
      var name = this.toString().match(/^function\s*([^\s(]+)/)[1];;
      Object.defineProperty(this, 'name', {value: name})
      return name;
    }
  });
}
