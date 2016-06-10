# #Plugin template

# This is an plugin template and mini tutorial for creating pimatic plugins. It will explain the
# basics of how the plugin system works and how a plugin should look like.

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an envirement object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take
  # a look at the dependencies section in pimatics package.json


  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  HongKongWeather = require "hongkong-weather"
  hko = new HongKongWeather()

  # Include you own depencies with nodes global require function:
  #
  #     someThing = require 'someThing'
  #

  # ###MyPlugin class
  # Create a class that extends the Plugin class and implements the following functions:
  class HongKongWeatherPlugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins`
    #     section of the config.json file
    #
    #
    init: (app, @framework, @config) =>
      env.logger.info("Hello World")

      deviceConfigDef = require("./device-config-schema")

      @framework.deviceManager.registerDeviceClass("HKWeatherDevice", {
        configDef: deviceConfigDef.HKWeatherDevice,
        createCallback: (config) => new HKWeatherDevice(config)
      })

  class HKWeatherDevice extends env.devices.Device
    attributes:
      temperature:
        description: "Regional Temperature"
        type: "number"
        unit: '°C'
        acronym: 'T'
      humidity:
        description: "Relative Humidity"
        type: "number"
        unit: '%'
        acronym: 'RH'
      uvIndex:
        description: "UV Index"
        type: "number"
        acronym: 'UVidx'
      uvIntensity:
        description: "UV Intensity"
        type: "string"
        acronym: 'UVint'


    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @weatherStation = @config.weatherStation
      @interval = @config.interval
      super()

      @requestWeather()
      @intervalTimerid = setInterval(@requestWeather, @interval)

    destroy: () ->
      clearInterval @intervalTimerid if @intervalTimerid?
      super()

    requestWeather: () =>
      return @_currentRequest = hko.getCurrent().then( (weather) =>
        console.log weather
        @emit "temperature", Number weather.regional.degrees_c
        @emit "humidity", Number weather.regional.humidity_pct
        @emit "uvIndex", Number weather.regional.uv_index if weather.regional.uv_index?
        @emit "uvIntensity", String weather.regional.uv_intensity if weather.regional.uv_intensity?
        #@emit "status", weathe
        #@emit "windspeed", Number results[0].current.windspeed
        return weather
      ).catch( (error) =>
        env.logger.error(error.message)
        env.logger.debug(error)
      )

    getTemperature: -> @_currentRequest.then( (weather) => Number weather.regional.degrees_c )
    getHumidity: -> @_currentRequest.then( (weather) => Number weather.regional.humidity_pct )
    getUvIndex: -> @_currentRequest.then( (weather) => Number weather.regional.uv_index )
    getUvIntensity: -> @_currentRequest.then( (weather) => String weather.regional.uv_intensity )
    #getWindspeed : -> @_currentRequest.then( (weather) => Number weather.current.windspeed )

  # ###Finally
  # Create a instance of my plugin
  hongKongWeatherPlugin = new HongKongWeatherPlugin

  # For testing...
  hongKongWeatherPlugin.HKWeatherDevice = HKWeatherDevice

  # and return it to the framework.
  return hongKongWeatherPlugin
