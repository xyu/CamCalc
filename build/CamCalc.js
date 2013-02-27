/*!
 * CamCalc v0.0.1
 * Calculator for camera focal distances
 * https://github.com/xyu/CamCalc
 *
 * Copyright 2013 Xiao Yu, @HypertextRanch
 * Released under the MIT license
 *
 * Date: Tue Feb 26 2013 19:17:11
 */
(function() {
  var CamCalc, root, _ref;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  CamCalc = root.CamCalc = (_ref = root.CamCalc) != null ? _ref : {};

}).call(this);

(function() {

  CamCalc.ApertureSnap = (function() {

    function ApertureSnap(options) {
      this.steps = options.steps || 1 / 3;
    }

    ApertureSnap.prototype.updateSettings = function(options) {
      if (options.steps) {
        return this.steps = options.steps;
      }
    };

    ApertureSnap.prototype.calculate = function(targetN) {
      var AV, snapAV;
      AV = this._calculateAV(targetN);
      snapAV = this._snapAV(AV);
      return {
        aperture: this._calculateN(snapAV)
      };
    };

    ApertureSnap.prototype.getStops = function(minN, maxN) {
      var N, maxAV, minAV, stops;
      minAV = this._snapAV(this._calculateAV(minN)) - this.steps;
      maxAV = this._snapAV(this._calculateAV(maxN)) + this.steps;
      stops = [];
      while ((minAV += this.steps) <= maxAV) {
        N = this._calculateN(minAV);
        if (N >= minN && N <= maxN) {
          stops.push(N);
        }
      }
      return stops;
    };

    ApertureSnap.prototype._calculateAV = function(N) {
      return Math.log(Math.pow(N, 2)) / Math.LN2;
    };

    ApertureSnap.prototype._calculateN = function(AV) {
      var N;
      N = Math.sqrt(Math.pow(2, AV));
      if (N >= 22.6 && N < 22.7) {
        return 22;
      }
      if (N >= 10) {
        return Math.round(N);
      }
      return Math.round(N * 10) / 10;
    };

    ApertureSnap.prototype._snapAV = function(targetAV) {
      var AV, diff, max, min, snapAV, snapDiff, steps, _i, _len;
      min = Math.floor(targetAV) - this.steps;
      max = Math.floor(targetAV) + 1;
      steps = (function() {
        var _results;
        _results = [];
        while ((min += this.steps) <= max) {
          _results.push(min);
        }
        return _results;
      }).call(this);
      snapAV = 0;
      snapDiff = 1;
      for (_i = 0, _len = steps.length; _i < _len; _i++) {
        AV = steps[_i];
        diff = Math.abs(AV - targetAV);
        if (diff < snapDiff) {
          snapAV = AV;
          snapDiff = diff;
        }
      }
      return snapAV;
    };

    return ApertureSnap;

  })();

}).call(this);

(function() {

  CamCalc.DepthOfField = (function() {

    function DepthOfField(options) {
      this.coc = (options.coc || 29) / 1000;
      this.aperture = options.aperture || 4;
      this.focalLength = options.focalLength || 50;
      this.distance = (options.distance || 3) * 1000;
    }

    DepthOfField.prototype.updateSettings = function(options) {
      if (options.coc) {
        this.coc = options.coc / 1000;
      }
      if (options.aperture) {
        this.aperture = options.aperture;
      }
      if (options.focalLength) {
        this.focalLength = options.focalLength;
      }
      if (options.distance) {
        return this.distance = options.distance * 1000;
      }
    };

    DepthOfField.prototype.calculate = function() {
      var Uf, Un, dV;
      dV = this._calculateFocusSpread(this.coc, this.aperture);
      Un = this._calculateLimitNear(dV, this.focalLength, this.distance);
      Uf = this._calculateLimitFar(Un, this.distance);
      return {
        nearLimit: Un / 1000,
        farLimit: Uf / 1000,
        depth: this._calculateDepth(Un, Uf) / 1000
      };
    };

    DepthOfField.prototype._calculateFocusSpread = function(c, N) {
      return N * Math.sqrt(562500 * Math.pow(c, 2) - Math.pow(N, 2)) / 375;
    };

    DepthOfField.prototype._calculateLimitNear = function(dV, f, U) {
      var denominator, numerator1, numerator2, sqrtInner1, sqrtInner2;
      sqrtInner1 = Math.pow(U - f, 2) * Math.pow(dV, 2);
      sqrtInner2 = Math.pow(f, 2) * Math.pow(U, 2);
      numerator1 = f * Math.sqrt(sqrtInner1 + sqrtInner2);
      numerator2 = (Math.pow(f, 2) * U) - (Math.pow(f, 2) * dV);
      denominator = (U - 2 * f) * dV + 2 * Math.pow(f, 2);
      return (numerator1 + numerator2) / denominator;
    };

    DepthOfField.prototype._calculateLimitFar = function(Un, U) {
      if (2 * Un <= U) {
        return Infinity;
      }
      return (Un * U) / (2 * Un - U);
    };

    DepthOfField.prototype._calculateDepth = function(Un, Uf) {
      if (!isFinite(Uf)) {
        return Infinity;
      }
      return Uf - Un;
    };

    return DepthOfField;

  })();

}).call(this);

(function() {

  CamCalc.IdealAperture = (function() {

    function IdealAperture(options) {
      this.focalLength = options.focalLength || 50;
      this.objectNear = (options.objectNear || 4) * 1000;
      this.objectFar = (options.objectFar || 5) * 1000;
      this._swapDistances();
    }

    IdealAperture.prototype.updateSettings = function(options) {
      if (options.focalLength) {
        this.focalLength = options.focalLength;
      }
      if (options.objectNear) {
        this.objectNear = options.objectNear * 1000;
      }
      if (options.objectFar) {
        this.objectFar = options.objectFar * 1000;
      }
      return this._swapDistances();
    };

    IdealAperture.prototype.calculate = function() {
      return {
        aperture: this._calculateAperture(this.objectNear, this.objectFar, this.focalLength),
        distance: this._calculateDistance(this.objectNear, this.objectFar) / 1000
      };
    };

    IdealAperture.prototype._calculateAperture = function(Un, Uf, f) {
      return Math.sqrt(375 * ((Un * f) / (Un - f) - (Uf * f) / (Uf - f)));
    };

    IdealAperture.prototype._calculateDistance = function(Un, Uf) {
      return (2 * Un * Uf) / (Un + Uf);
    };

    IdealAperture.prototype._swapDistances = function() {
      var tmp;
      if (this.objectNear <= this.objectFar) {
        return;
      }
      tmp = this.objectNear;
      this.objectNear = this.objectFar;
      return this.objectFar = tmp;
    };

    return IdealAperture;

  })();

}).call(this);
