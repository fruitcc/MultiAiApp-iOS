#!/bin/bash

echo "Setting up MultiAiApp Xcode project..."

# Check if xcodegen is installed
if ! command -v xcodegen &> /dev/null; then
    echo "XcodeGen is not installed. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first."
        echo "Visit: https://brew.sh"
        exit 1
    fi
    brew install xcodegen
fi

# Generate the Xcode project
echo "Generating Xcode project..."
xcodegen generate

# Open the project if generation was successful
if [ -d "MultiAiApp.xcodeproj" ]; then
    echo "Project generated successfully!"
    echo "Opening in Xcode..."
    open MultiAiApp.xcodeproj
else
    echo "Failed to generate project. Please check the error messages above."
    exit 1
fi