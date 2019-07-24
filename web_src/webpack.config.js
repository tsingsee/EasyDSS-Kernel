const HtmlWebpackPlugin = require('html-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const WrapperPlugin = require('wrapper-webpack-plugin');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const webpack = require('webpack');
const path = require('path');
const fs = require('fs');
const uglify = require('uglify-js');

function resolve(dir) {
    return path.resolve(__dirname, dir)
}

module.exports = {
    entry: {
        "index": ['babel-polyfill', resolve('src/index.js')],
        "share": ['babel-polyfill', resolve('src/share.js')]
    },
    output: {
        path: resolve('../kernel/www'),
        chunkFilename: 'js/[name].[chunkhash:8].js',
        filename: 'js/[name].[chunkhash:8].js'
    },
    externals: {
        jquery: 'window.$',
        'video.js': 'videojs'
    },
    resolve: {
        extensions: ['.js', '.vue', '.json'],
        alias: {
            'vue$': 'vue/dist/vue.common.js',
            'src': resolve('src'),
            'assets': resolve('src/assets'),
            'components': resolve('src/components')
        }
    },
    devServer: {
        host: '0.0.0.0',
        useLocalIp: true,
        proxy: {
            "*": {
                target: 'http://127.0.0.1:10088',
                secure: false
            }
        }
    },
    module: {
        rules: [{
            test: /\.js$/,
            loader: 'babel-loader',
            include: [resolve('src'), resolve('node_modules/pretty-bytes')]
        }, {
            test: /\.vue$/,
            loader: 'vue-loader',
            options: {
                loaders: {
                    css: ExtractTextPlugin.extract({
                        publicPath: '../',
                        fallback: 'vue-style-loader', //this is a dep of vue-loader, so no need to explicitly install if using npm3
                        use: 'css-loader'
                    })
                },
                postcss: [
                    require('autoprefixer')()
                ]
            }
        }, {
            test: /\.css$/,
            use: ExtractTextPlugin.extract({
                publicPath: '../',
                fallback: "style-loader",
                use: "css-loader"
            })
        },
        {
            test: /\.less$/,
            use: ExtractTextPlugin.extract({
                publicPath: '../',
                fallback: "style-loader",
                use: "css-loader!less-loader"
            })
        },
        {
            test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
            loader: 'url-loader',
            options: {
                outputPath: "images/",
                limit: 10000,
                name: "[name].[hash:8].[ext]"
            } 
        },
        {
            test: /\.(woff2?|eot|ttf|otf)(\?.*)?$/,
            loader: 'url-loader',
            options: {
                outputPath: "fonts/",
                limit: 10000,
                name: "[name].[hash:8].[ext]"
            }
        },
        {
            test: /\.(swf|mp4|webm|ogg|mp3|wav|flac|aac)(\?.*)?$/,
            loader: 'url-loader',
            options: {
                outputPath: "media/",
                limit: 10000,
                name: "[name].[hash:8].[ext]"
            }
        }]
    },
    plugins: [
        new webpack.ProvidePlugin({
            $: 'jquery',
            jQuery: 'jquery',
            "window.jQuery": 'jquery',
            "window.$": 'jquery',
            videojs: "video.js",
            "window.videojs": "video.js"
        }),
        new webpack.HashedModuleIdsPlugin(),
        new CopyWebpackPlugin([
            { from: 'src/externals' },
            // { from: 'node_modules/@easydarwin/easy-player/dist/component/EasyPlayer-lib.min.js', to: 'js/'},
            // { from: 'node_modules/@easydarwin/easy-player/dist/component/EasyPlayer.swf'}
        ]),
        new ExtractTextPlugin("css/[name].[chunkhash:8].css"),      
        new HtmlWebpackPlugin({
            filename: 'index.html',
            title: 'EasyDSS',
            inject: true, // head -> Cannot find element: #app
            chunks: ['index'],
            template: './src/template.html'
        }),
        new HtmlWebpackPlugin({
            filename: 'share.html',
            title: 'EasyDSS',
            inject: true,
            chunks: ['share'],
            template: './src/template.html'
        })
    ]
};

if (process.env.NODE_ENV == "production") {
    module.exports.plugins = (module.exports.plugins || []).concat([
        new CleanWebpackPlugin(['dist/www'], {
            root: resolve("../")
        }),
        new webpack.DefinePlugin({
            'process.env': {
                NODE_ENV: '"production"'
            }
        }),
        new OptimizeCssAssetsPlugin({
            assetNameRegExp: /\.css$/g,
            cssProcessor: require('cssnano'),
            cssProcessorOptions: { discardComments: { removeAll: true } },
            canPrint: true
        }),          
        new webpack.optimize.UglifyJsPlugin({
            comments: false,
            compress: {
              warnings: false
            }
        })
    ])
}