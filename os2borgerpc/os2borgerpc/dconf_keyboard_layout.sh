#! /usr/bin/env sh

# SYNOPSIS
#    dconf_keyboard_layout.sh [ENFORCE]
#
# DESCRIPTION
#    This script installs a policy that adds a keyboard layout and as a
#    side effect it makes the keyboard layout switcher viewable in the menu bar
#
#    Use a boolean to decide whether to enforce or not. An unchecked box will
#    remove the policy and a checked one will enforce it.
#
# IMPLEMENTATION
#    copyright       Copyright 2022, Magenta ApS
#    license         GNU General Public License

set -x

if get_os2borgerpc_config os2_product | grep --quiet kiosk; then
  echo "Dette script er ikke designet til at blive anvendt på en kiosk-maskine."
  exit 1
fi

ACTIVATE=$1
LANGUAGE_TO_ADD=$2 # Example: ua for Ukrainian

# Change these three to set a different policy to another value
POLICY_PATH="org/gnome/desktop/input-sources"
POLICY="sources"
POLICY_VALUE="[('xkb','dk'),('xkb','$LANGUAGE_TO_ADD')]"

POLICY_FILE="/etc/dconf/db/os2borgerpc.d/00-keyboard-layout"
POLICY_LOCK_FILE="/etc/dconf/db/os2borgerpc.d/locks/00-keyboard-layout"

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
	rm --force "$POLICY_FILE" "$POLICY_LOCK_FILE"
fi

# Incorporate all of the text files we've just created into the system's dconf databases
dconf update
