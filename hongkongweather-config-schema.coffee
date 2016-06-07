# #my-plugin configuration options
# Declare your config option for your plugin here.
module.exports = {
  title: "Hong Kong Weather Config Options"
  type: "object"
  properties:
    debug:
      description: "Debug mode. Writes debug messages to the pimatic log, if set to true."
      type: "boolean"
      default: false
}
