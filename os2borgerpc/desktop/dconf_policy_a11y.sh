#!/usr/bin/env sh

# SYNOPSIS
#    dconf_policy_a11y.sh [ENFORCE]
#
# DESCRIPTION
#    This script installs a policy that forces the Universal Access menu to be
#    shown at all times.
#
#    Use a boolean to decide whether to enforce or not. An unchecked box will
#    remove the policy and a checked one will enforce it.
#
# IMPLEMENTATION
#    version         dconf_policy_a11y.sh (magenta.dk) 1.1.0
#    author          Alexander Faithfull
#    copyright       Copyright 2022, Magenta ApS
#    license         GNU General Public License
#    email           af@magenta.dk

set -x

# Change these three to set a different policy to another value
POLICY_PATH="org/gnome/desktop/a11y"
POLICY="always-show-universal-access-status"
POLICY_VALUE="true"

POLICY_FILE="/etc/dconf/db/os2borgerpc.d/00-accessibility"
POLICY_LOCK_FILE="/etc/dconf/db/os2borgerpc.d/locks/accessibility"

ACTIVATE=$1

if [ "$ACTIVATE" = 'True' ]; then
	mkdir --parents "$(dirname "$POLICY_FILE")" "$(dirname "$POLICY_LOCK_FILE")"

	# dconf does not, by default, require the use of a system database, so
	# add one (called "os2borgerpc") to store our system-wide settings in
	cat > "/etc/dconf/profile/user" <<-END
		user-db:user
		system-db:os2borgerpc
	END

	cat > "$POLICY_FILE" <<-END
		[$POLICY_PATH]
		$POLICY=$POLICY_VALUE
	END
	# "dconf update" will only act if the content of the keyfile folder has
	# changed: individual files changing are of no consequence. Force an update
	# by changing the folder's modification timestamp
	touch "$(dirname "$POLICY_FILE")"

	# Tell the system that the values of the dconf keys we've just set can no
	# longer be overridden by the user
	cat > "$POLICY_LOCK_FILE" <<-END
		/$POLICY_PATH/$POLICY
	END
else
	rm -f "$POLICY_FILE" "$POLICY_LOCK_FILE"
fi

# Incorporate all of the text files we've just created into the system's dconf databases
dconf update
