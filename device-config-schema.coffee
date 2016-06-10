module.exports = {
  title: "pimatic-hongkongweather device config schemas"
  HKWeatherDevice: {
    title: "HKWeatherDevice config options"
    type: "object"
    properties:
      weatherStation:
        description: "string of the weather station"
        type: "string"
        default: ""
      interval:
        description: "the delay between polls of weather server"
        type: "integer"
        default: "5000"
  }
}
