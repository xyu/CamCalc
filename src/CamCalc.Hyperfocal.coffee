class CamCalc.Hyperfocal
  constructor: (options) ->
    @coc         = ( options.coc         || 29 ) / 1000 #microns
    @aperture    = ( options.aperture    || 4  )        #f-stop
    @focalLength = ( options.focalLength || 50 )        #mm

  updateSettings: (options) ->
    @coc         = options.coc / 1000      if options.coc
    @aperture    = options.aperture        if options.aperture
    @focalLength = options.focalLength     if options.focalLength

  calculate: ->
    H = _calculateHyperfocalDistance.call(this, @focalLength, @aperture, @coc)
    
    return {
      distance: H / 1000,
      nearLimit: H / 2000,
      farLimit: Infinity,
      depth: Infinity,
    }

  _calculateHyperfocalDistance= (f, N, c) ->
    #       f^2
    # H = ------- + f
    #      N * c
    
    return ( Math.pow(f, 2) / ( N * c ) ) + f
