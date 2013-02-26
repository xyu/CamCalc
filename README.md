#CamCalc

Calculator for camera focal distances

## Usage

Include either build/CamCalc.js or build/CamCalc.min.js into your page then you will have access to the `CamCalc` object, which allow the creation of 3 different calculators.

Each calculator is instantiated with a settings array that contains data needed to perform its particular function. Settings can be updated at anytime via the `updateSettings()` method as well. For example:

```js
var dof = new CamCalc.DepthOfField({
  aperture: 1.8,
  distance: 5
})

dof.calculate()

dof.updateSettings({
  aperture: 8,
  focalLength: 24
})

dof.calculate()
```

### CamCalc.DepthOfField()

Calculates the depth of field that can be achieved with the given camera, lens, and focal distance used.

#### Options

* `coc` (microns, default: 29)

  The circle of confusion of your camera sensor (if you want maximum sharpness) given the same sized sensor, say 35mm full frame, the higher the resolution the smaller the coc.

* `aperture` (f-number, default: 4)

  The aperture of the lens you are using for the shot.

* `focalLength` (mm, default: 50)

  The focal length of the lens you are using.

* `distance` (meters, default: 3)

  The distance to the object you are focusing on.

#### Methods

* `updateSettings()`

  Update calculator settings.

* `calculate()`

  Returns an object with values in meters
  * `depth` - Total distance between near and far focal points.
  * `farLimit` - Distance to the far focal point.
  * `nearLimit` - Distance to the near focal point.

### CamCalc.IdealAperture()

Calculates the ideal aperture given the lens and focal distance used.

#### Options

* `focalLength` (mm, default: 50)

  The focal length of the lens you are using.

* `objectNear` (meters, default: 4)

  The distance to the closest object you care about.

* `objectFar` (meters, default: 5)

  The distance to the furthest object you care about.

#### Methods

* `updateSettings()`

  Update calculator settings.

* `calculate()`

  Returns an object with the following values
  * `aperture` - The mathematically ideal f-number, which may not be an actual stop available on your lens. (See below)
  * `distance` - Distance in meters to focus to.

### CamCalc.ApertureSnap()

`CamCalc.IdealAperture()` will probably return a f-number that you can't actually set on a real life lens. This will calculate what f-stop an f-number is closest to.

#### Options

* `steps` (default: 1/3)

  Most modern lenses & cameras allow setting apertures in 1/3 stops.

#### Methods

* `updateSettings()`

  Update calculator settings.

* `getStops(min f-number, max f-number)`

  Takes min and max f-number then returns all the available stops in-between.

* `calculate(f-number)`

  Takes an f-number and returns an object with the following.
  * `aperture` - The closest available f-stop.

## License

Copyright (c) 2013 Xiao Yu, @HypertextRanch

Licensed under the MIT license.