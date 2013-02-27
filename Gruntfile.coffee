module.exports = (grunt) ->

  pkg = require './package.json'

  # Project configuration
  grunt.initConfig
    pkg: pkg
    clean:
      build: [
        'build/*'
      ]
    coffeelint:
      source: 'src/*.coffee'
      grunt: 'Gruntfile.coffee'
    coffee:
      options:
        bare: false
      compile:
        files:
          'build/CamCalc.js': [
            'src/CamCalc.coffee'
            'src/CamCalc.*.coffee'
          ]
    uglify:
      build:
        options:
          banner: """
/*! #{pkg.name} v#{pkg.version} | (c) #{grunt.template.today('yyyy')} #{pkg.author} | #{pkg.license} license */

"""
        files:
          'build/CamCalc.min.js': [
            'build/CamCalc.js'
          ]
    concat:
      addbanner:
        options:
          banner: """
/*!
 * #{pkg.name} v#{pkg.version}
 * #{pkg.description}
 * #{pkg.repository.url}
 *
 * Copyright #{grunt.template.today('yyyy')} #{pkg.author}
 * Released under the #{pkg.license} license
 *
 * Date: #{grunt.template.today()}
 */

"""
        src: [
          'build/CamCalc.js'
        ]
        dest: 'build/CamCalc.js'

  # Dependencies
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-concat'

  # Aliases
  grunt.registerTask 'default', [
    'clean:build'
    'coffeelint:source'
    'coffee:compile'
    'uglify:build'
    'concat:addbanner'
  ]
