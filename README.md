# This is a script to install multiple versions of R on linux systemes that are not using R studio server pro

The original documentation for installing multiple version of R on linux can be found [here](https://support.rstudio.com/hc/en-us/articles/215488098-Installing-multiple-versions-of-R-on-Linux).

### Table of contents
I. [Resources](#Resources) \
II. [Installation](#Installation) \
III. [Example](#Example) \
IV. [Installing Rstudio server](#Installing-Rstudio-server) \
V. [Troubleshooting](#Troubleshooting) \
VI. [Closing remarks](#Closing-remarks) \
VII. [Removing Rstudio server](#Removing-Rstudio-server)

### I. Resources
#### Availible R versions (minor R versions can be found in the links below).
 - [R-1](https://cran.r-project.org/src/base/R-1/)
 - [R-2](https://cran.r-project.org/src/base/R-2/)
 - [R-3](https://cran.r-project.org/src/base/R-3/)
 - [R-4](https://cran.r-project.org/src/base/R-4/)

### Installation

Clone this repo from GitHub.

```bash=
git@github.com:nasiegel88/installR.git
```

Once the script is downloaded you will need to make it executable.
```bash=
chmod u+x installR.sh
```
Note the script needs to be run as root and will not start without root.
```bash=
# Wrong
$ ./installR.sh 
This script must be run as root.
```

`-a` is the major R version and `-b` is the minor R version
```bash=
# Correct
$ sudo ./installR.sh 
Some or all of the parameters are empty

Usage: ./installR.sh -a parameterA -b parameterB
	-a Major R version i.e. 4
	-b Minor R version i.e. 4.1.3
```

### Example

The code below will install R_4.1.3 to the `/opt` directory.
```bash=
sudo ./installR.sh -a '4' -b '4.1.3'
```

Assuming Rstudio server is installed on the system launch the server and `4.1.3` should be the version running in Rstudio.

```bash=
sudo rstudio-server start
```

And if the default port is being used users should go to `localhost:8787` using their browser of choice.

![](https://i.imgur.com/6xK96YP.png)

To install another version of R run the chunk below.
```bash=
sudo ./installR.sh -a 4 -b 4.1.2
```
This will install a different version of R. In order to get Rstudio server to recognize the R version has been changed `rserver.conf` will need to be edited. The shell script below will make rstudio studio run what ever installed version of R is passed through the `-b` argument.
```bash=
chmod u+x changeR.sh
sudo ./changeR.sh -b 4.1.2
```
Then the server will need to restarted to Rstudio to recognize the change.
```bash=
sudo rstudio-server restart
```

![](https://i.imgur.com/aoHfOxp.png)

To double check that the desired version of R is being run in Rstudio enter the command listed below in the Rstudio console.
```r=
R.version

platform       x86_64-pc-linux-gnu         
arch           x86_64                      
os             linux-gnu                   
system         x86_64, linux-gnu           
status                                     
major          4                           
minor          1.2                         
year           2021                        
month          11                          
day            01                          
svn rev        81115                       
language       R                           
version.string R version 4.1.2 (2021-11-01) # The correct version is being used!
nickname       Bird Hippie
```

### Installing Rstudio server

```bash
sudo apt-get install gdebi-core
```

```bash
# Download load the most recent version of R studio server
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.02.2-485-amd64.deb
```

```bash
# Run the executable
sudo gdebi rstudio-server-2022.02.2-485-amd64.deb
# clean up
rm rstudio-server-2022.02.2-485-amd64.deb 
```

### Troubleshooting

Rstudio server should now be ready to run. If there are issues starting the server try some of the solutions listed below... 

I. Try telling rstudio server where to located the R
```bash
echo "export RSTUDIO_WHICH_R='/opt/R/4.1.3/bin/R'" >> ~/.profile 
```

II. If the open source version of rstudio server is being used remove `rserver.conf` and restart the server.
```bash
sudo rm /etc/rstudio/rserver.conf
```

III. If a very old version of R is being installed, such as anything pre-3.0 users may have an issue launching Rstudio server. If that is the case it is recommended to in install an older version of Rstudio server. Debian builds for Debian and Ubuntu can be found [here](https://dailies.rstudio.com/rstudio/prairie-trillium/server/debian9/). If the goal is to run R from the command line then then skip this step.

### Closing remarks

It is nice to be able to switch between R versions in Rstudio with a few clicks however, to ensure reproducibility it is recommended to run R in something like [mybinder](https://the-turing-way.netlify.app/communication/binder/zero-to-binder.html) or [rocker](https://github.com/rocker-org/rocker) (docker images for R and Rstudio) and to manager software in an environment using a package manager such as [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/getting-started.html).

### Removing Rstudio server

```bash
sudo apt-get remove --purge rstudio-server
```
