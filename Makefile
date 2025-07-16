.PHONY: build clean

# === CONFIGURATION ===
SCHEME = GhostScreenSaver
PROJECT = GhostScreenSaver.xcodeproj
CONFIGURATION = Debug
SDK = macosx

# === COMMANDS ===

## Build the macOS app
build:
	xcodebuild \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-sdk $(SDK) \
		-configuration $(CONFIGURATION) \
		build | xcpretty

## Clean the project
clean:
	xcodebuild \
		-project $(PROJECT) \
		-scheme $(SCHEME) \
		-sdk $(SDK) \
		clean | xcpretty
