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
        files:
          'build/CamCalc.min.js': [
            'build/CamCalc.js'
          ]

  # Dependencies
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'

  # Aliases
  grunt.registerTask 'default', [
    'clean:build'
    'coffeelint:source'
    'coffee:compile'
    'uglify:build'
  ]
