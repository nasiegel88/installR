#!/bin/bash

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

# Begin script in case all parameters are correct
echo "$parameterA"
echo "$parameterB"

# Install r-base if it is not already installed
REQUIRED_PKG="r-base"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get build-dep $REQUIRED_PKG
fi

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
/opt/R/$parameterB/bin/R --version

# Create a symlink to R if they do not already exist
sudo ln -sfn /opt/R/$parameterB/bin/R /usr/local/bin/R
sudo ln -sfn /opt/R/$parameterB/bin/Rscript /usr/local/bin/Rscript

# Export path so Rstudio can find it
export RSTUDIO_WHICH_R=$(which /opt/R/$parameterB/bin/R)

# Clean up

rm $parameterB.tar.gz
rm -rf $parameterB
