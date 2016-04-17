#!/bin/bash

if uname | grep -q Darwin; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cudnn/v4rc/lib
elif uname | grep -q Linux; then
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cudnn/v4rc/lib64
fi

echo
echo - - - - - - - - - - - - - - - - - - - 
echo Preparing to benchmark Marvin...
echo - - - - - - - - - - - - - - - - - - -
echo
echo Please select a Network:
echo 1. \[A\]lexNet
echo 2. \[G\]oogleNet
echo 3. \[V\]gg

read -n1 -p '> ' net_name 

net="None"

if [ "A" = "$net_name" -o "a" = "$net_name" ]; then
	net="alexnet"
elif [ "G" = "$net_name" -o "g" = "$net_name" ]; then
	net="googlenet"
elif [ "V" = "$net_name" -o "v" = "$net_name" ]; then
	net="vgg"
else
	echo Unknown net name.
	exit 1
fi

echo
echo
echo Please select Data:
echo 1. \[I\]magenet
echo 2. \[P\]laces

read -n1 -p '> ' data_name

data="None"

if [ "I" = "$data_name" -o "i" = "$data_name" ]; then
        data="imagenet"
elif [ "P" = "$data_name" -o "p" = "$data_name" ]; then
        data="places"
else
        echo Unknown data name.
        exit 1
fi

echo
echo
echo Beginning training...
echo
echo Setup? \[y/n\]
read -n1 -p '> ' needs_setup
echo
if [ "Y" = "$needs_setup" -o "y" = "$needs_setup" ]; then
	code="setup('"$net"','"$data"');quit();"
	echo $code
        (cd benchmark && matlab -r $code)
fi
echo


dir=$net'_'$data
./marvin train models/$dir/$dir.json -bench

echo
echo
echo Need teardown? \[y/n\]
read -n1 -p '> ' needs_teardown
if [ "Y" = "$needs_teardown" -o "y" = "$needs_teardown" ]; then
	code="setup('"$net"','"$data"');quit();"
        echo $code
	(cd benchmark && matlab -r $code)
fi
echo
