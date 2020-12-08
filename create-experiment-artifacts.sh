#!/bin/bash



current_directory=pwd

rm -rf temp_1225456 
mkdir temp_1225456
cd temp_1225456

mkdir Git

cd Git

mkdir algorand-go-implementation

mkdir coordinator

cd algorand-go-implementation

#----------
cd ~/Git/algorand-go-implementation
make 
cd -
#----------

cp ~/Git/algorand-go-implementation/algorand-go-implementation ./
cp ~/Git/algorand-go-implementation/create-network-with-registery-trickle.sh ./
cp ~/Git/algorand-go-implementation/kill-processes.sh ./

cd ../coordinator

#----------
cd ~/Git/coordinator
./build-service.sh
cd -
#----------

cp ~/Git/coordinator/service-app ./

cd ../../

cp ~/Git/simple-speed-test-server/distribution_amd64_linux.zip ./


rm  ../experiment-artifacts.zip

zip -r ../experiment-artifacts.zip ./Git distribution_amd64_linux.zip

cd ..

rm -rf temp_1225456 




