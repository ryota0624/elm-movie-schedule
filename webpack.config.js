const notifier = require('node-notifier');
const Min = require("webpack").optimize.UglifyJsPlugin
class WatchDone {
  apply(compiler) {
    compiler.plugin('done', stats => this.compileDone(stats));
  }

  compileDone(stats) {
    notifier.notify({
      message: 'compile done',
      title: 'webpack',
      sound: 'Pop'
    });
  }
}

module.exports = {
  devtool: "source-map",
  entry: './src/index.js',
  output: {
    path: './bundle',
    filename: 'app.js'
  },
  resolve: {
    modules: [
      'node_modules'
    ],
  },
  module: {
    loaders: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack'
      },
      // all files with a `.ts` or `.tsx` extension will be handled by `ts-loader`
      { test: /\.ts(x)?$/, loader: 'ts-loader' },
      { test: /\.json/, loader: 'json-loader' },
      { test: /\.css$/, loader: 'style-loader!css-loader' },
      { test: /\.eot(\?v=\d+\.\d+\.\d+)?$/, loader: 'file' },
      { test: /\.(woff|woff2)$/, loader: 'url?prefix=font/&limit=5000' },
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url?limit=10000&mimetype=application/octet-stream',
      },
      { test: /\.svg(\?v=\d+\.\d+\.\d+)?$/, loader: 'url?limit=10000&mimetype=image/svg+xml' },
    ]
  },
  plugins: [
    new WatchDone
    // new Min()
 ],
  devServer: {
    inline: true,
    contentBase: 'bundle',
    proxy: {
      '/schedule': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
      '/movie': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      }
    },
    stats: { colors: true },
  }
}