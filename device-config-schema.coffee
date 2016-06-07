module.exports = {
  title: "pimatic-hongkongweather device config schemas"
  HKWeatherDevice: {
    title: "HKWeatherDevice config options"
    type: "object"
    properties:
      weatherStation:
        description: "string of the weather station"
        format: String
        default: ""
      interval:
        description: "the delay between polls of weather server"
        format: Number
        default: "5000"
  }
}
