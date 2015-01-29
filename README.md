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

## Deploy

slc deploy http://{server:port}/{config} master

## Writing End to End tests (e2e)

[Webdriver API](http://selenium.googlecode.com/git/docs/api/javascript/index.html)
[Webdriver Wiki](https://code.google.com/p/selenium/wiki/WebDriverJs)
