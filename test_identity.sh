ensure_rhsm_subscription() {

### Note commenting out 'log [info|warning|critical] because I am logging for this scenario.

    local ORG="change_me"
    local ACTKEY="change_me"

    # If the system is NOT registered, attempt registration
    if ! subscription-manager identity >/dev/null 2>&1; then
        #log warning "System is not registered to RHSM. Attempting registration."
	echo "System is not registered to RHSM. Attempting registration."

        if [[ -z "$ORG" || -z "$ACTKEY" ]]; then
            #log critical "RHSM_ORG and/or RHSM_ACTIVATION_KEY not set. Cannot register."
	    echo "RHSM_ORG and/or RHSM_ACTIVATION_KEY not set. Cannot register."
            return 1
        fi

        if ! subscription-manager register \
            --org="$ORG" \
            --activationkey="$ACTKEY" \
            --force \
            >/dev/null 2>&1; then
            #log critical "subscription-manager register failed."
	    echo "subscription-manager register failed."
            return 1
        fi

        #log info "subscription-manager register completed successfully."
	echo "subscription-manager register completed successfully."
        return 0
    fi

    # System IS registered → refresh entitlements
    #log info "RHSM identity present. Running: subscription-manager refresh"
    echo "RHSM identity present. Running: subscription-manager refresh"

    if ! subscription-manager refresh --force >/dev/null 2>&1; then
        #log error "subscription-manager refresh failed."
	echo "subscription-manager refresh failed."
        return 1
    fi

    #log info "subscription-manager refresh completed successfully."
    echo "subscription-manager refresh completed successfully."
}

ensure_rhsm_subscription || echo "RHSM sync failed."
