const path = require("path");
const webpack = require("webpack");
module.exports = {
  devtool: "source-map", // Enable source maps
  entry: path.resolve(__dirname, "./src/index.tsx"), // Your entry point
  module: {
    rules: [
      {
        test: /\.(js|jsx|ts|tsx)$/,
        exclude: /node_modules/,
        use: ["babel-loader"],
      },
      {
        test: /\.css$/i,
        use: ["style-loader", "css-loader"], // Order matters: css-loader first, then style-loader
      },
    ],
  },
  resolve: {
    extensions: [".js", ".jsx", ".ts", ".tsx"], // To allow importing files without specifying extension
  },
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "bundle.js",
  },
  plugins: [
    new (require("html-webpack-plugin"))({
      template: path.resolve(__dirname, "./index.html"),
      filename: "index.html",
      inject: "body",
    }),
  ],
  // Other webpack configurations
};
