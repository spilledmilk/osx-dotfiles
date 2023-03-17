# Make sure Node version is correct
brew install node@18
brew unlink node
brew link --overwrite node@18
node -v
