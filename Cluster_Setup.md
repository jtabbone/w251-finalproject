Below is the instruction of setting up the spark cluster (spark 2.1.1 on UBUNTU_LATEST_64) and install required softwares (Java, SBT, Spark, Cassandra).

## Step 1 - Provision Three VMs
Provision three UBUNTU_LATEST_64 VSes in SoftLayer with 2 CPUs, 4GB RAM and a 100GB local hard drive. Name them spark1, spark2, and spark3.
Private key HW4ID is stored on the local machine.
```
slcli vs create --datacenter=sjc01 --hostname=spark1 --domain=w251project.com --billing=hourly --key=HW4ID --cpu=2 --memory=4096 --disk=100 --network=1000 --os=UBUNTU_LATEST_64
slcli vs create --datacenter=sjc01 --hostname=spark2 --domain=w251project.com --billing=hourly --key=HW4ID --cpu=2 --memory=4096 --disk=100 --network=1000 --os=UBUNTU_LATEST_64
slcli vs create --datacenter=sjc01 --hostname=spark3 --domain=w251project.com --billing=hourly --key=HW4ID --cpu=2 --memory=4096 --disk=100 --network=1000 --os=UBUNTU_LATEST_64
```
Here are the nodes information. And the os is Ubuntu 16.04.3 LTS (GNU/Linux 4.4.0-89-generic x86_64).

- 45005193  spark1   198.23.84.68     10.90.120.211  sjc01
- 45005221  spark2   198.23.84.77     10.90.120.244  sjc01
- 45005229  spark3   198.23.84.75     10.90.120.248  sjc01

## Step 2 - Configure connectivity between machines
Configure each VM such that it can SSH to every other VM without passwords using SSH keys.
Copy private key whose name is HW4ID from local machine to each VM.
```
# go to the directory on the local machine where the private key file is
cd .ssh/
scp id_rsa root@198.23.84.68:~/.ssh
scp id_rsa root@198.23.84.77:~/.ssh
scp id_rsa root@198.23.84.75:~/.ssh
```

Configure known_hosts file '/etc/hosts' on each node with below contents. You may need to change the permission 'chmod 600 /root/.ssh/id_rsa'.
```
127.0.0.1 		localhost.localdomain localhost
198.23.84.68	spark1.w251project.com	spark1
198.23.84.77	spark2.w251project.com	spark2
198.23.84.75	spark3.w251project.com	spark3
```
Next, log in each machine from every other maching using syntax like 'ssh spark1' to make sure the connection works well.

## Step 3 - Install Java, SBT, Spark, and Cassandra on all nodes
Usefule reference: https://data-flair.training/blogs/apache-spark-installation-on-ubuntu/

Install Java:
```
sudo apt-get install python-software-properties
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
```

Install SBT
```
echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
sudo apt-get update
sudo apt-get install sbt
```

Set the proper location of JAVA_HOME and test it.
```
echo export JAVA_HOME=\"$(readlink -f $(which java) | grep -oP '.*(?=/bin)')\" >> /root/.bash_profile
source /root/.bash_profile
$JAVA_HOME/bin/java -version
```
You would expect output like:
```
java version "1.8.0_151"
Java(TM) SE Runtime Environment (build 1.8.0_151-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.151-b12, mixed mode)
```
 
Install Spark 2.1.1 using pre-built package
```
sudo apt-get install bc
curl https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz | tar -zx -C /usr/local --show-transformed --transform='s,/*[^/]*,spark,'
## For convenience, set $SPARK_HOME:
echo export SPARK_HOME=\"/usr/local/spark\" >> /root/.bash_profile
source /root/.bash_profile
```

Test sbt and spark. Use CTRL-D to exit the sbt or Spark shell
```
sbt
$SPARK_HOME/bin/spark-shell
```

Install Cassandra 
(http://cassandra.apache.org/download/)
```
# Add the Apache repository of Cassandra to /etc/apt/sources.list.d/cassandra.sources.list, for example for the latest 3.11 version:
echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list

# Add the Apache Cassandra repository keys:
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

# Update the repositories:
sudo apt-get update

# Install Cassandra:
sudo apt-get install cassandra


sudo service cassandra start

# Verify that Cassandra is running by invoking nodetool status from the command line.
nodetool status

#be sure to stop it if you need to make any configuration changes.
sudo service cassandra stop
```

## Step 4 - Configure and Start Spark from master
Below steps are applied to the master node (spark1) only.
On spark1, create the new file  $SPARK_HOME/conf/slaves  and content:
```
spark1
spark2
spark3
```
Start Spark from master
`$SPARK_HOME/sbin/start-master.sh`

Start slave nodes
`$SPARK_HOME/sbin/start-slaves.sh`

You can check the cluster status at: http://198.23.84.68:8080/

## Step 5 - Set up Cassandra on the cluster
Configure Cassandra on each node. 
Stop Cassandra first using 'sudo service cassandra stop' and edit below parts of /ect/cassandra/cassandra.yaml file on each node.
```
seeds: "198.23.84.68, 198.23.84.77, 198.23.84.75" 
listen_address: 198.23.84.68 
rpc_address: 198.23.84.68
```
Seeds should be the same on all nodes; listen_address and rpc_address are the IPs of the specific node.

Start cassandra on each node
```
cd /usr/sbin/
sudo sh cassandra -R
```
Go to any one of the node and check the status using `nodetool status`. You would see below output.
```
Datacenter: datacenter1
=======================
Status=Up/Down
|/ State=Normal/Leaving/Joining/Moving
--  Address       Load       Tokens       Owns (effective)  Host ID                                                  Rack
UN  198.23.84.68  171.26 KiB  256          67.3%             a06d6cec-6829-4fde-                   a798-d9bdd0a9f811  rack1
UN  198.23.84.77  174.86 KiB  256          66.8%             209b4b76-f1a5-456b-                   8859-4181a8d23d26  rack1
UN  198.23.84.75  174.75 KiB  256          65.9%             9fb79704-6b42-467f-                   ae78-68291943452f  rack1
```

You can also check if you can connect to the cluster using cqlsh, the Cassandra command line client. Note that you can specify the IP address of any node in the cluster for this command.
```
cqlsh 198.23.84.68 9042
```

## Step 6 - Install Jupyter Notebook on master
You can refer to https://techknight.eu/2016/01/03/setup-jupyter-notebook-centosrhel-7/ and https://www.youtube.com/watch?v=uhVYTNEe_-A to learn more.

Python2 is already installed with spark package. You can check the version `python --version` or start pyspark `$SPARK_HOME/bin/pyspark` to confirm.

Install packages and jupyter using below commands. Pandas is useful for later analysis but not necessary in this step.
```
apt-get update
apt-get -y install python-pip python-dev
# pip install --upgrade pip
pip install pandas
pip install jupyter
```

Next, generate a configuration file.
```
jupyter notebook --generate-config
```
And you should see an output like this where the path for the configuration file will be defined.
```
Writing default config to: /root/.jupyter/jupyter_notebook_config.py
```

Open python in the terminal with python and enter the commands below and remember to copy the hashed password. click Enter for the password. Then exit python.
```
>>> from notebook.auth import passwd
>>> passwd()
Enter password:
Verify password:
'sha1:43352c81e857:b3238223de81faff7afda3c18b79c7fe8e192fdc'
```

If you don’t have a valid certificate you should use a self-signed certificate to be able to use https://
```
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem
```
Now, we can update /root/.jupyter/jupyter_notebook_config.py with below contents.
``` 
c.NotebookApp.allow_root = True
# paste the hashed password in the string
c.NotebookApp.password = u''
c.NotebookApp.ip = '*'
c.NotebookApp.certfile = u'./mycert.pem'
c.NotebookApp.keyfile = u'./mykey.key'
c.NotebookApp.open_browser = False
```
Open port 8888 in the firewall
```
apt install firewalld
firewall-cmd --zone=public --add-port=8888/tcp --permanent
systemctl restart firewalld
```
Configure .bashrc and add below to the bottom of the file
```
function snotebook () 
{
#Spark path (based on your computer)
SPARK_PATH=/usr/local/spark

export PYSPARK_DRIVER_PYTHON="jupyter"
export PYSPARK_DRIVER_PYTHON_OPTS="notebook"

# For python 3 users, you have to add the line below or you will get an error 
#export PYSPARK_PYTHON=python3

$SPARK_PATH/bin/pyspark --master local[2]
}
```
```
source .bashrc
```

Now you can start jupyter notebook using `jupyter notebook` and go to http://198.23.84.68:8888 using token shown when you start the notebook as the example below.
```
[C 18:11:07.395 NotebookApp]

    Copy/paste this URL into your browser when you connect for the first time,
    to login with a token:
        http://localhost:8888/?token=900246c39ae1875c37b5b7013f7649138726daafbae8fef6
```
However using `jupyter notebook` command will not enable pyspark in jupyter notebook. If you want to use pyspark, please use below commmand.
```
source .bashrc
snotebook
```
