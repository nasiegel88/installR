#!/bin/bash

[[ $EUID -ne 0 ]] && echo "This script must be run as root." && exit 1

helpFunction()
{
   echo ""
   echo "Usage: $0 -b parameterB"
   echo -e "\t-b Minor R version i.e. 4.1.3"
   exit 1 # Exit script after printing help
}

while getopts "b:" opt
do
   case "$opt" in
      b ) parameterB="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterB" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "Rstudio server will now run R version $parameterB"

sed -i "2s/.*/rsession-which-r=|opt|R|$parameterB|bin|R/" /etc/rstudio/rserver.conf && \
sed -i 's/|/\//g' /etc/rstudio/rserver.conf

