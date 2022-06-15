#!/bin/bash

# Stop on fail!
set -e

[[ $EUID -ne 0 ]] && echo "This script must be run as root." && exit 1

helpFunction()
{
   echo ""
   echo "Usage: $0 -a parameterA -b parameterB"
   echo -e "\t-a Major R version i.e. 4"
   echo -e "\t-b Minor R version i.e. 4.1.3"
   exit 1 # Exit script after printing help
}

while getopts "a:b:" opt
do
   case "$opt" in
      a ) parameterA="$OPTARG" ;;
      b ) parameterB="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] || [ -z "$parameterB" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Print R version to be installed
echo "R version $parameterB will be installed in the /opt directory"

# Make /opt if it does not already exist
mkdir -p /opt

sleep 2

# Install r-base if it is not already installed
REQUIRED_PKG="r-base"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get build-dep $REQUIRED_PKG
fi

sleep 2

export R_VERSION=$parameterB

cd /opt && { curl -O https://cran.rstudio.com/src/base/R-$parameterA/R-$parameterB.tar.gz ; cd -; } && \
cd /opt && tar -xzvf R-$parameterB.tar.gz && \
cd R-${R_VERSION}


# Build and install R
./configure \
    --prefix=/opt/R/$parameterB \
    --enable-memory-profiling \
    --enable-R-shlib \
    --with-blas \
    --with-lapack

make
sudo make install


# Verify R installation
echo "Checking if $parameterB was installed successfully"

sleep 2

/opt/R/$parameterB/bin/R --version

if [ $? -eq 0 ]
then
    echo "R version $parameterB was installed successfully"
else
    echo -e "An error occured\n$parameterB was not installed"
fi

# Create a symlink to R if they do not already exist
sudo ln -sfn /opt/R/$parameterB/bin/R /usr/local/bin/R
sudo ln -sfn /opt/R/$parameterB/bin/Rscript /usr/local/bin/Rscript

# Export path so Rstudio can find it
export RSTUDIO_WHICH_R=$(which /opt/R/$parameterB/bin/R)

# Clean up
cd /opt && \
rm R-$parameterB.tar.gz && \
rm -rf R-$parameterB
