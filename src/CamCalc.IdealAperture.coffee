class CamCalc.IdealAperture
  constructor: (options) ->
    @focalLength = ( options.focalLength || 50 )        #mm
    @objectNear  = ( options.objectNear  || 4  ) * 1000 #m
    @objectFar   = ( options.objectFar   || 5  ) * 1000 #m
    this._swapDistances()

  updateSettings: (options) ->
    @focalLength = options.focalLength       if options.focalLength
    @objectNear  = options.objectNear * 1000 if options.objectNear
    @objectFar   = options.objectFar * 1000  if options.objectFar
    this._swapDistances()

  calculate: ->
    return {
      aperture: this._calculateAperture(@objectNear, @objectFar, @focalLength),
      distance: this._calculateDistance(@objectNear, @objectFar) / 1000,
    }

  _calculateAperture: (Un, Uf, f) ->
    #                    Un * f     Uf * f
    # N = sqrt( 375 * ( -------- - -------- ) )
    #                    Un - f     Uf - f
    
    return Math.sqrt( 375 * ( (Un*f)/(Un-f) - (Uf*f)/(Uf-f) ) )

  _calculateDistance: (Un, Uf) ->
    #      2 * Un * Uf
    # U = -------------
    #        Un + Uf
    
    return ( 2 * Un * Uf ) / ( Un + Uf )

  _swapDistances: ->
    return if @objectNear <= @objectFar
    
    tmp = @objectNear
    @objectNear = @objectFar
    @objectFar = tmp
