#!/usr/bin/env bash

# curl -sL https://raw.githubusercontent.com/kikitux/curl-bash/master/provision/add_github_user_public_keys.sh | GITHUB_USER=kikitux bash

if [ ! "${GITHUB_USER}" ]; then
  echo "warn: this script ${0} needs GITHUB_USER variable"
  echo "info: exiting without doing any change"
  exit
fi

# set base
# if we are in sudo use the calling user
# we use eval as ~ won't be expanded
if [ "${SUDO_USER}" ]; then
  BASE="`eval echo ~${SUDO_USER}/.ssh`"
else
  BASE="`eval echo ~/.ssh`"
fi

# create base if doesn't exist
[ -d ${BASE} ] || mkdir -p ${BASE}

if ! [[ -f ${BASE}/authorized_keys ]]; then
  echo "Creating new ${BASE}/authorized_keys"
  touch ${BASE}/authorized_keys
fi

OIFS=$IFS   # Save current IFS
IFS=$'\n'   # Change IFS to new line
keys=(`curl -sL https://api.github.com/users/${GITHUB_USER}/keys | jq -r '.[].key'`)
IFS=$OIFS   # Restore IFS

for i in ${!keys[@]}; do

  grep -q "${keys[i]}" ${BASE}/authorized_keys &>/dev/null || {
    cat >> ${BASE}/authorized_keys <<EOF
${keys[i]}
EOF
  }
done

if [ "${SUDO_USER}" ]; then
  chown ${SUDO_USER} ${BASE} ${BASE}/authorized_keys
fi

chmod 0700 ${BASE}
chmod 0600 ${BASE}/authorized_keys

