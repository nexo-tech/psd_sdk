## 0.2.3

- **BREAKING FIX**: Fixed null check operator error when parsing PSD files with Unicode layer names
- **NEW**: Added full support for Unicode (Japanese, Chinese, etc.) characters in layer names
- **FIX**: Fixed parsing stopping after first few layers due to incorrect padding calculation for Unicode sections
- **NEW**: Added configurable debug logging system with `PsdLogging` class
- **NEW**: Added comprehensive test coverage for Unicode layer name handling
- **IMPROVEMENT**: Removed all print statements from library code, replaced with proper logging
- **NEW**: Added custom log handler support for better integration with application logging
- Added example PSD file with Unicode layer names for testing (`example/test_unicode.psd`)
- Improved error handling in layer mask section parsing
- Enhanced layer hierarchy building with proper null checks
- Added tests to verify no print statements in library code

## 0.2.2

- Updated SDK versions for better compatibility

## 0.2.1

- Updated SDK constraints to support modern Dart runtimes

## 0.2.0

- Converted static classes to proper Dart enums for better type safety and idiomatic Dart code
- Added `fromValue` methods to all enums for proper value conversion
- Improved documentation and code organization
- Updated SDK constraints to support modern Dart runtimes
- Enhanced cross-platform compatibility

## 0.1.6

- Added nullchecks in interleave functions.

## 0.1.5

- Added documentation

## 0.1.4

- Get last error function

## 0.1.3

- API cleanup

## 0.1.2

- Updated readme

## 0.1.1

- Cleanup

## 0.1.0

- Initial version, created by Stagehand
