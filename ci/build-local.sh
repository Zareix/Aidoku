#!/bin/sh
# Build local : archive l'app dans le dossier d'archives de Xcode
# pour la retrouver dans l'Organizer (Window > Organizer), d'où on peut
# la distribuer à la main (TestFlight, ad-hoc…).
#
# Usage : ./ci/build-local.sh [--export]
#   --export : génère aussi une IPA App Store dans build/export/
#              (uploadable ensuite à la main via Organizer/Transporter)

set -e

PROJECT="Aidoku.xcodeproj"
SCHEME="Aidoku"
TEAM="KC74NH6SS8"
TODAY="$(date +%Y-%m-%d)"
ARCHIVE_DIR="$HOME/Library/Developer/Xcode/Archives/$TODAY"
ARCHIVE="$ARCHIVE_DIR/Aidoku $(date +%H.%M.%S).xcarchive"

mkdir -p "$ARCHIVE_DIR"

xcodebuild -project "$PROJECT" -scheme "$SCHEME" \
	-destination 'generic/platform=iOS' \
	-archivePath "$ARCHIVE" archive \
	-allowProvisioningUpdates

echo ""
echo "✅ Archive créée : $ARCHIVE"
echo "   → Xcode > Window > Organizer pour la distribuer (TestFlight, ad-hoc…)"

if [ "${1:-}" = "--export" ]; then
	EXPORT_DIR="$(pwd)/build/export"
	xcodebuild -exportArchive \
		-archivePath "$ARCHIVE" \
		-exportPath "$EXPORT_DIR" \
		-exportOptionsPlist "$(pwd)/ci/app-store-exportoptions.plist" \
		-allowProvisioningUpdates
	echo "📦 IPA App Store : $EXPORT_DIR"
fi
