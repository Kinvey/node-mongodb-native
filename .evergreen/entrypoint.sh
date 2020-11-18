echo "Getting ${DRIVER_REPOSITORY}@${DRIVER_REVISION} version ${DRIVER_VERSION}"
git clone --depth 1 -b v${DRIVER_VERSION} $DRIVER_REPOSITORY driver_src
cd driver_src

# Install desired version of Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> "$HOME/.bashrc
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> "$HOME/.bashrc

nvm install --no-progress $NODE_VERSION && npm install --silent

# Run the tests with the provided MONGODB_URI
if [ $DRIVER_VERSION == "3.6.0" ]; then
  echo "Latest version, running modern tests"
  MONGODB_URI=${MONGODB_URI} npx mocha --recursive test/functional test/unit
  echo "Ran tests"
else
  echo "Old version, running legacy tests (currently broken)"
  ./node_modules/.bin/mongodb-test-runner -s -l -e single test/core test/unit test/functional
fi
