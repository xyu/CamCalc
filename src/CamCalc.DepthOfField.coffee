class CamCalc.DepthOfField
  constructor: (options) ->
    @coc         = ( options.coc         || 29 ) / 1000 #microns
    @aperture    = ( options.aperture    || 4  )        #f-stop
    @focalLength = ( options.focalLength || 50 )        #mm
    @distance    = ( options.distance    || 3  ) * 1000 #m

  updateSettings: (options) ->
    @coc         = options.coc / 1000      if options.coc
    @aperture    = options.aperture        if options.aperture
    @focalLength = options.focalLength     if options.focalLength
    @distance    = options.distance * 1000 if options.distance

  calculate: ->
    dV = _calculateFocusSpread.call(this, @coc, @aperture)
    Un = _calculateLimitNear.call(this, dV, @focalLength, @distance)
    Uf = _calculateLimitFar.call(this, Un, @distance)
    
    return {
      distance: @distance / 1000,
      nearLimit: Un / 1000,
      farLimit: Uf / 1000,
      depth: _calculateDepth.call(this, Un, Uf) / 1000,
    }

  _calculateFocusSpread= (c, N) ->
    #       N * sqrt( 562500 * c^2 - N^2 )
    # dV = --------------------------------
    #                    375
    
    return N * Math.sqrt( 562500 * Math.pow(c, 2) - Math.pow(N, 2) ) / 375

  _calculateLimitNear= (dV, f, U) ->
    #       f * sqrt( (U-f)^2 * dV^2 + f^2 * U^2 ) + f^2 * U - f^2 * dV
    # Un = -------------------------------------------------------------
    #                       ( U - 2*f ) * dV + 2 * f^2
    
    sqrtInner1 = Math.pow(U-f, 2) * Math.pow(dV, 2)
    sqrtInner2 = Math.pow(f, 2) * Math.pow(U, 2)
    
    numerator1 = f * Math.sqrt(sqrtInner1 + sqrtInner2)
    numerator2 = (Math.pow(f, 2) * U) - (Math.pow(f, 2) * dV)
    denominator = ( U - 2*f ) * dV + 2 * Math.pow(f, 2)

    return (numerator1 + numerator2) / denominator

  _calculateLimitFar= (Un, U) ->
    #         Un * U
    # Uf = ------------
    #       2 * Un - U
    
    return Infinity if 2 * Un <= U
    return (Un * U) / (2 * Un - U)

  _calculateDepth= (Un, Uf)->
    return Infinity if !isFinite(Uf)
    return Uf - Un
