#!/usr/bin/env bash

### Note: You can switch out echo with log commands if you wish to log outputs (like tee, log, logger, etc...)

ORG="change_me"
ACTKEY="change_me"

# If the system is NOT registered, attempt registration
if ! subscription-manager identity >/dev/null 2>&1; then
echo "System is not registered to RHSM. Attempting registration."
	if [[ -z "$ORG" || -z "$ACTKEY" ]]; then
	    echo "RHSM_ORG and/or RHSM_ACTIVATION_KEY not set. Cannot register."
            return 1
        fi

        if ! subscription-manager register \
            --org="$ORG" \
            --activationkey="$ACTKEY" \
            --force \
            >/dev/null 2>&1; then
	    echo "subscription-manager register failed."
            return 1
        fi

	echo "subscription-manager register completed successfully."
        return 0
fi

# System IS registered → refresh entitlements
echo "RHSM identity present. Running: subscription-manager refresh"
    if ! subscription-manager refresh --force >/dev/null 2>&1; then
	echo "subscription-manager refresh failed."
        return 1
    fi

echo "subscription-manager refresh completed successfully."
