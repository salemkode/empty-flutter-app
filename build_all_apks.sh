#!/bin/bash

# Script to build APK for all branches and rename them

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create output directory
OUTPUT_DIR="build_apks"
mkdir -p "$OUTPUT_DIR"

# Get list of local branches only (excluding remotes and HEAD)
BRANCHES=$(git branch --format='%(refname:short)' | grep -v "remotes" | grep -v "HEAD")

echo -e "${GREEN}Starting APK build for all branches...${NC}"
echo ""

# Get current branch to return to it later
CURRENT_BRANCH=$(git branch --show-current)

# Stash any uncommitted changes
HAS_CHANGES=$(git status --porcelain)
if [ -n "$HAS_CHANGES" ]; then
    echo "Stashing uncommitted changes..."
    git stash push -m "Auto-stash before building APKs"
    STASHED=true
else
    STASHED=false
fi

# Counter for success/failure
SUCCESS_COUNT=0
FAIL_COUNT=0

for BRANCH in $BRANCHES; do
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}Building APK for branch: $BRANCH${NC}"
    echo -e "${YELLOW}========================================${NC}"
    
    # Checkout branch (force checkout to discard any local changes)
    echo "Checking out branch: $BRANCH"
    git checkout -f "$BRANCH" 2>&1
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to checkout branch: $BRANCH${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        continue
    fi
    
    # Clean previous builds
    echo "Cleaning previous builds..."
    flutter clean > /dev/null 2>&1
    
    # Get dependencies
    echo "Getting dependencies..."
    flutter pub get > /dev/null 2>&1
    
    # Build APK
    echo "Building APK..."
    flutter build apk --release
    
    if [ $? -eq 0 ]; then
        # APK path
        APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
        
        if [ -f "$APK_PATH" ]; then
            # Rename and copy to output directory
            NEW_NAME="${BRANCH}.apk"
            cp "$APK_PATH" "$OUTPUT_DIR/$NEW_NAME"
            echo -e "${GREEN}✓ Successfully built: $NEW_NAME${NC}"
            SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
        else
            echo -e "${RED}✗ APK file not found at: $APK_PATH${NC}"
            FAIL_COUNT=$((FAIL_COUNT + 1))
        fi
    else
        echo -e "${RED}✗ Failed to build APK for branch: $BRANCH${NC}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
    
    echo ""
done

# Return to original branch
echo "Returning to original branch: $CURRENT_BRANCH"
git checkout -f "$CURRENT_BRANCH" > /dev/null 2>&1

# Restore stashed changes if any
if [ "$STASHED" = true ]; then
    echo "Restoring stashed changes..."
    git stash pop > /dev/null 2>&1
fi

# Summary
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Build Summary:${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "Successfully built: ${GREEN}$SUCCESS_COUNT${NC} APKs"
echo -e "Failed: ${RED}$FAIL_COUNT${NC} builds"
echo ""
echo -e "All APKs are saved in: ${GREEN}$OUTPUT_DIR/${NC}"
echo ""

