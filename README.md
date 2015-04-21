# Loopback Boilerplate

Boilerplate to set up a Loopback application with the following technologies:

* gulp
* sass
* react
* client side loopback models
* react-loopback data bindings
* coffeescript client and server
* shared utilities code between client and server
* loopback backend api

# Development/Maintenance Instructions

## Installation

1. Install Node.js: [http://nodejs.org/](http://nodejs.org/)
2. Install git: [http://git-scm.com/](http://git-scm.com/)
3. Install sass: gem install sass

Then, at the command line:

```bash
cd where-ever/you-put-projects
git clone https://github.com/TorchlightSoftware/loopback-boiler.git
cd loopback-boiler
npm install -g strongloop mocha gulp bower
npm install
bower install
```

## Running

```bash
gulp livereload &
gulp build &
slc run
```

## Develop

For the server side, just [add models](http://docs.strongloop.com/display/public/LB/Creating+models), and customize with [remote methods](http://docs.strongloop.com/display/public/LB/Remote+methods).

For the client side, just add [routes](https://github.com/rackt/react-router) and [views](http://facebook.github.io/react/docs/component-specs.html).

## Deploy

slc deploy http://{server:port}/{config} master

## Writing End to End tests (e2e)

[Webdriver API](http://selenium.googlecode.com/git/docs/api/javascript/index.html)

[Webdriver Wiki](https://code.google.com/p/selenium/wiki/WebDriverJs)

## LICENSE

(MIT License)

Copyright (c) 2014 Torchlight Software <info@torchlightsoftware.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
