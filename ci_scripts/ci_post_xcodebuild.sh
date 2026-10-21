#!/bin/sh

# Copy the distribution logs (export errors) into the build artifacts,
# otherwise Xcode Cloud only shows "exit-code: 70" with no explanation.
if [ -n "$IDEDistributionLogDirectory" ] && [ -d "$IDEDistributionLogDirectory" ]; then
	mkdir -p "$CI_ARTIFACTS_DIRECTORY/distribution-logs"
	cp -R "$IDEDistributionLogDirectory"/ "$CI_ARTIFACTS_DIRECTORY/distribution-logs/" || true
fi
