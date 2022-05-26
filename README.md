# This is a script to install multiple versions of R on linux systemes that are not using R studio server pro

The original documentation for installing multiple version of R on linux can be found [here](https://support.rstudio.com/hc/en-us/articles/215488098-Installing-multiple-versions-of-R-on-Linux).

### Resources
#### Availible R versions (minor R version can be found in the links below)
 - [R-1](https://cran.r-project.org/src/base/R-1/)
 - [R-2](https://cran.r-project.org/src/base/R-2/)
 - [R-3](https://cran.r-project.org/src/base/R-3/)
 - [R-4](https://cran.r-project.org/src/base/R-4/)

### Installation

This repo can either be cloned or the installation script can be download directly from GitHub.

Cloning repo
```bash
```

Downloading script via command line
```bash
```

One the script is downloaded you will need to make it executible.
```bash
chmod u+x installR.sh
```
Note script needs to be run as root and will not start without root
```bash
# Wrong
$ ./installR.sh 
This script must be run as root.
```

`-a` is the major R version and `-b` is the minor R version
```bash
# Correct
$ sudo ./installR.sh 
Some or all of the parameters are empty

Usage: ./installR.sh -a parameterA -b parameterB
	-a Major R version i.e. 4
	-b Minor R version i.e. 4.1.3
```

#### Example

The code below will install R_4.1.3 to the `/opt` directory.
```bash
sudo ./installR.sh -a '4' -b '4.1.3'
```

Assuming Rstudio server is installed on the system launch the server and `4.1.3` should be the version runninger in Rstudio.

#### Installing Rstudio server

```bash
sudo apt-get install gdebi-core
```

```bash
# Download load the most recent version of R studio server
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.02.2-485-amd64.deb
```

```bash
# Run the executible
sudo gdebi rstudio-server-2022.02.2-485-amd64.deb -y
# clean up
rm rstudio-server-2022.02.2-485-amd64.deb 
```

#### Trouble shooting

Rstudio server should now be ready to run. If there are issues starting the server try some of the solutions listed below... 

I. Try telling rstudio server where to located the R
```bash
echo "export RSTUDIO_WHICH_R='/opt/R/4.1.3/bin/R'" >> ~/.profile 
```

II. If the open source version of rstudio server is being used remove `rserver.conf` and restart the server
```bash
sudo rm /etc/rstudio/rserver.conf
```

#### Removing Rstudio server

```bash
sudo apt-get remove --purge rstudio-server
```