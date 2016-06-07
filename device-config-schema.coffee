module.exports = {
  title: "pimatic-hongkongweather device config schemas"
  PingPresence: {
    title: "HongKongWeather config options"
    type: "object"
    extensions: ["xLink", "xPresentLabel", "xAbsentLabel"]
    properties:
      weatherStation:
        description: "string of the weather station"
        type: "string"
        default: ""
      interval:
        description: "the delay between polls of weather server"
        type: "number"
        default: 5000
  }
}
