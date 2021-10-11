#!/bin/bash

rm new_package.json
rm -rf node_modules
rm -rf yarn.lock
rm package-lock.json

# clean package.json
dependencies=$(awk 'BEGIN{flag=0} /dependencies/{flag=1; next} /\}/{flag=0} flag{print $1}' package.json | cut -f 2 -d '"' | sort -u)
devDependencies=$(awk 'BEGIN{flag=0} /devDependencies/{flag=1; next} /\}/{flag=0} flag{print $1}' package.json | cut -f 2 -d '"' | sort -u)
awk 'BEGIN{flag=1} /dependencies/{print; flag=0} /\}/{flag=1} flag{print}' package.json | awk 'BEGIN{flag=1} /devDependencies/{print; flag=0} /\}/{flag=1} flag{print}' | tee new_package.json
cat new_package.json > package.json

# install dependencies and devDependencies
yarn add -D ${devDependencies}
yarn add ${dependencies}

# Fix versions of errant packages which won't work with latest versions
# eslint v8 is not compatible with all eslint plugins in this project
sed -i 's/"eslint": .*"/"eslint": "\^7.0.0"/g' package.json

# clean old or unwanted files
rm new_package.json
rm -rf node_modules
rm -rf yarn.lock
rm package-lock.json

# install in one-shot
yarn