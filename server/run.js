require('coffee-script/register');
app = require('./server');
if (require.main === module) {
  app.start();
}
