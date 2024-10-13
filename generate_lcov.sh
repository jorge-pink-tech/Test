#!/bin/bash

# Create the coverage directory if it doesn't exist
mkdir -p coverage/APIs

# Run llvm-cov export with the ignore regex to generate an empty lcov report
llvm-cov export --format=lcov \
  --ignore-filename-regex="Core|DataAccess|Services|.build" \
  --instr-profile=merged.profdata \
  ./Library/APIs/.build/debug/APIsPackageTests.xctest/Contents/MacOS/APIsPackageTests > coverage/APIs/full-lcov.info

if [ -f "coverage/APIs/full-lcov.info" ]; then
    echo "LCOV report generated successfully at coverage/APIs/full-lcov.info"

    # Filter the report to only include sections related to files under APIs/AuthenticationApi/Sources
    awk '/^SF:.*APIs\/AuthenticationApi\/Sources/{keep=1} /^SF:/&&!/APIs\/AuthenticationApi\/Sources/{keep=0} {if(keep) print}' coverage/APIs/full-lcov.info > coverage/APIs/lcov.info

    # Check if the filtered report was generated successfully
    if [ -f "coverage/APIs/lcov.info" ]; then
        echo "Filtered LCOV report created at coverage/APIs/lcov.info"
    else
        echo "Failed to create filtered LCOV report."
        exit 1
    fi
else
    echo "Failed to generate LCOV report."
    exit 1
fi
