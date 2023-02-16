# Rive animation in macOS dock

https://user-images.githubusercontent.com/30288967/219434221-040049f0-c527-4e16-8a97-964e5ab8dc9f.mov

#

This demo shows how to run [Rive](rive.app) animation in a macOS dock using [Flutter](https://flutter.dev/) and [NSDockTile](https://developer.apple.com/documentation/appkit/nsdocktile) API.

Please note that refreshing the NSDockTile with a 60FPS rate is working fine, but remember that this API was never designed for real-time rendering. This demo is highly CPU-consuming.

Inspiration:
- [Rive Use Cases](https://rive.app/use-cases#:~:text=macOS%20dock%20icons,with%20animated%20graphics.)
- [Rive Workshop - MacOS dock icons](https://www.youtube.com/watch?v=G9eMwIJ6ZlA)
- [flutter_in_dock](https://github.com/ueman/flutter_in_dock)
