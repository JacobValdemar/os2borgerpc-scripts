#! /usr/bin/env sh

# Removes lock screen from the menu - also removes the related keybind as an intended side effect

set -x

lower() {
	echo "$@" | tr '[:upper:]' '[:lower:]'
}

ACTIVATE="$(lower "$1")"

# Change these three to set a different policy to another value
POLICY_PATH="org/gnome/desktop/lockdown"
POLICY="disable-lock-screen"
POLICY_VALUE="true"

POLICY_FILE="/etc/dconf/db/os2borgerpc.d/00-$POLICY"
POLICY_LOCK="/etc/dconf/db/os2borgerpc.d/locks/00-$POLICY"


if [ "$ACTIVATE" != 'false' ] && [ "$ACTIVATE" != 'falsk' ] && \
   [ "$ACTIVATE" != 'no' ] && [ "$ACTIVATE" != 'nej' ]; then

	mkdir --parents "$(dirname $POLICY_FILE)" "$(dirname $POLICY_LOCK)"

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
	cat > "$POLICY_LOCK" <<-END
		/$POLICY_PATH/$POLICY
	END
else
	rm -f "$POLICY_FILE" "$POLICY_LOCK"
fi

# Incorporate all of the text files we've just created into the system's dconf databases
dconf update
