# GreatCircle
GreatCircle is an Swift framework that provides a set of extensions to the [`CLLocation`](https://developer.apple.com/documentation/corelocation/cllocation) class.

## The Problem
The `CLLocation` class provides only one method: 

```swift
func distance(from location: CLLocation) -> CLLocationDistance
```

For calculating the distance between two GPS locations. Because of this, Swift developers must "roll their own" to solve more complex GPS location calculation 
problems.

## The Solution
[GreatCircle](https://github.com/keithsharp/GreatCircle) provides a comprehensive set of extension methods to the `CLLocation` class that
make working with GPS locations and performing calculations on then simple and easy.

GreatCircle is a example of standing on the shoulders of giants:
+ It's a Swift port of the [Objective C GreatCircle](https://github.com/softwarenerd/GreatCircle) library by [Brian Lambert](https://github.com/softwarenerd)
+ Which is, in turn, based upon the work of [Chris Veness](https://github.com/chrisveness), the owner of the [Geodesy functions](https://github.com/chrisveness/geodesy) project

(For a more general introduction, see: [Movable Type Scripts Latitude / Longitude Calculations Reference](http://www.movable-type.co.uk/scripts/latlong.html))

## Copyright and License
GreatCircle is Copyright 2020, Keith Sharp and is licensed under the MIT License:
```
The MIT License (MIT)

Copyright (c) 2020 Keith Sharp.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```