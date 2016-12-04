const config = require('./webpack.config');
const Min = require("webpack").optimize.UglifyJsPlugin;

config.plugins.push(new Min);

module.exports = config;