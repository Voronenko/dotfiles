# yse with source
echo "sourcing REMOTE_HOST REMOTE_USER_INITIAL/ubuntu/ REMOTE_PASSWORD_INITIAL/empty/ BOX_DEPLOY_USER/ubuntu/ BOX_DEPLOY_PASS"
export REMOTE_HOST=$1
export REMOTE_USER_INITIAL=${2:-ubuntu}
export REMOTE_PASSWORD_INITIAL=$4
export BOX_DEPLOY_USER=${4:-ubuntu}
# if you use sudo
export BOX_DEPLOY_PASS=$5
