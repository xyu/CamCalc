class CamCalc.IdealAperture
  constructor: (options) ->
    @focalLength = ( options.focalLength || 50 )        #mm
    @objectNear  = ( options.objectNear  || 4  ) * 1000 #m
    @objectFar   = ( options.objectFar   || 5  ) * 1000 #m
    _swapDistances.call(this)

  updateSettings: (options) ->
    @focalLength = options.focalLength       if options.focalLength
    @objectNear  = options.objectNear * 1000 if options.objectNear
    @objectFar   = options.objectFar * 1000  if options.objectFar
    _swapDistances.call(this)

  calculate: ->
    return {
      aperture: _calculateAperture.call(
        this,
        @objectNear,
        @objectFar,
        @focalLength
      ),
      distance: _calculateDistance.call(
        this,
        @objectNear,
        @objectFar
      ) / 1000,
    }

  _calculateAperture= (Un, Uf, f) ->
    #                    Un * f     Uf * f
    # N = sqrt( 375 * ( -------- - -------- ) )
    #                    Un - f     Uf - f
    
    return Math.sqrt( 375 * ( (Un*f)/(Un-f) - (Uf*f)/(Uf-f) ) )

  _calculateDistance= (Un, Uf) ->
    #      2 * Un * Uf
    # U = -------------
    #        Un + Uf
    
    return ( 2 * Un * Uf ) / ( Un + Uf )

  _swapDistances= ->
    return if @objectNear <= @objectFar
    
    tmp = @objectNear
    @objectNear = @objectFar
    @objectFar = tmp
