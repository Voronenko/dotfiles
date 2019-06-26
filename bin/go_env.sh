# use with source
# optional:  export GOOWNER for github.com/goowner
# optional:  export GL_URL for custom sources location
# optiomal:  export GO_PROJECT_NAMESPACE if checkouted in a custom dir
CURRENT_DIR=${PWD##*/}
GOROOT=${GOROOT:-$PWD/.go}
GOOWNER=${GOOWNER:-voronenko}
GOPATH_CURRENT="$(pwd)/.go"

export GL_URL=${GL_URL:-github.com/$GOOWNER}
export GO_PROJECT_NAMESPACE=${GO_PROJECT_NAMESPACE:-$CURRENT_DIR}
if [ ! -d $(pwd)/.go ]
then
mkdir -p $(pwd)/.go/src/$GL_URL
ln -s $(pwd) $(pwd)/.go/src/$GL_URL/$GO_PROJECT_NAMESPACE
fi
export GOPATH="${GOPATH_CURRENT}:$GOROOT"
export GOBIN=${GOPATH_CURRENT}/bin
export PATH=$GOBIN:$PATH
export GO_PROJECT_PATH=$(pwd)/.go/src/$GL_URL/$GO_PROJECT_NAMESPACE
echo "try cd \$GO_PROJECT_PATH"

