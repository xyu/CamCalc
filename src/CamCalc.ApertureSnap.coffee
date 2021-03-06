class CamCalc.ApertureSnap
  constructor: (options) ->
    @steps = ( options.steps || 1/3 )

  updateSettings: (options) ->
    @steps = options.steps if options.steps

  calculate: (targetN) ->
    AV = _calculateAV.call(this, targetN)
    snapAV = _snapAV.call(this, AV)
    
    return {
      aperture: _calculateN.call(this, snapAV)
    }

  getStops: (minN, maxN) ->
    minAV = _snapAV.call(this, _calculateAV.call(this, minN)) - @steps
    maxAV = _snapAV.call(this, _calculateAV.call(this, maxN)) + @steps
    
    stops = []
    while (minAV += @steps) <= maxAV
      N = _calculateN.call(this, minAV)
      stops.push(N) if (N >= minN && N <= maxN)
      
    return stops

  _calculateAV= (N) ->
    # AV = log2( N^2 )
    
    return Math.log( Math.pow(N, 2) ) / Math.LN2

  _calculateN= (AV) ->
    # N = sqrt( 2^AV )
    
    N = Math.sqrt( Math.pow(2, AV) )
    #special case for f/22 which is actually f/22.6
    return 22 if (N >= 22.6 && N < 22.7)
    return Math.round( N ) if N >= 10
    return Math.round( N * 10 ) / 10

  _snapAV= (targetAV) ->
    min = Math.floor(targetAV) - @steps
    max = Math.floor(targetAV) + 1
    
    steps = while (min += @steps) <= max
      min
    
    snapAV = 0
    snapDiff = 1
    
    for AV in steps
      diff = Math.abs(AV - targetAV)
      (snapAV = AV; snapDiff = diff) if diff < snapDiff
      
    return snapAV
