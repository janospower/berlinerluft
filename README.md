# Berliner Luft

Value Driven Graphics Prototype

## Design Files

The static designs, wireframes and more can be accessed at

* [Figma project #1](https://www.figma.com/file/VAPQAmvQK9DfR0SLiJCDibYH/Value-Driven-Graphics-%E2%80%93-Hauptprojekt)

and

* [Figma project #2](https://www.figma.com/file/NUeDPYbKkxPZyWnSdh2WOQYO/Framer-Light-Janos)

## Known Quirks and Issues

Please read before running:
* Localhost necessary.
* Optimized for Desktop Safari but should run okay on different platforms with the exception being the font size of some dynamic text elements.
* Clicks are not always successfully differentiated from other gestures, which can result in accidental clicks registering on `mouseup` when trying to drag, pinch or scroll clickable elements.
* To pinch: press and hold the `option` key, then move the cursor slightly before starting to drag.
* The detail view can be accessed by clicking on the `radon` point cloud. Please note that this graph is only pinchable on mobile devices, on a desktop, just use the scrolling gesture to zoom in and out.
* The majority of the onscreen keyboard is sometimes underneath invisible layers. If unresponsive, please click on the bottom section of the screen.
* For more guidance but less of a polished look, enable hints for interactive elements by changing line No. 4 of `app.coffee` to `Framer.Extras.Hints.enable()` and recompile.
* To preview the red background simply click the last point cloud.


## Dozent

* [Dipl. Designer Torsten Malcherczyk MA](mailto:tm@achtender.com)

## Contributors

* [**Philine Schell 558968**](mailto:philine@borderstep.net)

* [**Janos Pauer 558011**](mailto:me@janospauer.com)

## Built With

* Love

* Framer.js

* D3.js

* THREE.js
