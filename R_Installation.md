Below is the step of installing R and RStudio Server on CENTOS 7.

## Step 1: Update the system
```
# yum clean all
sudo yum install epel-release
sudo yum update
sudo shutdown -r now
```
After the reboot, use the same sudo user to log in back.

## Step 2: Install R
`sudo yum install R -y`

## Step 3: Install RStudio Server
check https://www.rstudio.com/products/rstudio/download-server/ for latest version
```
cd
wget https://download2.rstudio.org/rstudio-server-rhel-1.1.383-x86_64.rpm
sudo yum install --nogpgcheck rstudio-server-rhel-1.1.383-x86_64.rpm
```
After the installation, the RStudio Server service should have gotten started. You can check its status and set it to run on boot as below:
```
sudo systemctl status rstudio-server.service
sudo systemctl enable rstudio-server.service
```

## Step 4: Access RStudio Server from a web browser
In order to allow web access, you need to modify firewall settings as below:
```
systemctl enable firewalld
systemctl start firewalld
sudo firewall-cmd --permanent --zone=public --add-port=8787/tcp
sudo firewall-cmd --reload
```
Now you can point your web browser to http://<your IP>:8787
have issue logging in RStudio server!!

## Start R
`R`

## Start sparkR
```
cd $SPARK_HOME
```
./bin/sparkR
