#! /usr/bin/env sh

ACTIVATE=$1

POLICY_LOCK_FILE=/etc/dconf/db/os2borgerpc.d/locks/02-launcher-favorites

# Locks the menu so it can't be edited (adding/removing/moving items in the menu)
if [ "$ACTIVATE" = 'True' ]; then
	cat <<- EOF > $POLICY_LOCK_FILE
		/org/gnome/shell/favorite-apps
	EOF
else
	rm $POLICY_LOCK_FILE
fi

dconf update
