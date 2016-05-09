echo '*** Prepare ***'
sudo apt-get install git -y
sudo apt-get install maven -y
sudo apt-get install openssh-server -y
sudo apt-get update -y
sudo apt-get install software-properties-common python-software-properties -y
sudo apt-get install rpl -y
echo '*** Preparation completed ***'


ssh-keyegen -t rsa -P ""
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
ssh zroot@localhost


echo '*** Java 8 installation ***'
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
sudo apt-get install oracle-java8-installer -y
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle' >> /etc/profile
source /etc/profile
ln -s /usr/lib/jvm/java-8-oracle /usr/lib/jvm/default-java
echo java -version
echo '*** Java 8 installed ***'



wget http://ftp.byfly.by/pub/apache.org/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz

tar -xvzf hadoop-2.7.2.tar.gz
mv hadoop-2.7.2 hadoop
sudo mv hadoop /usr/local/

HADOOP_BASE_DIR=/usr/local/hadoop
HADOOP_BASE_CONFIG_DIR=$HADOOP_BASE_DIR/etc/hadoop

mkdir -p $HADOOP_BASE_DIR/yarn_data/hdfs/namenode
mkdir -p $HADOOP_BASE_DIR/yarn_data/hdfs/datanode


echo '<configuration>
    <property>
        <name>fs.default.name</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>' > $HADOOP_BASE_CONFIG_DIR/core-site.xml



echo '<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>' > $HADOOP_BASE_CONFIG_DIR/mapred-site.xml



echo '<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:/usr/local/hadoop/yarn_data/hdfs/namenode</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:/usr/local/hadoop/yarn_data/hdfs/datanode</value>
    </property>    
</configuration>' > $HADOOP_BASE_CONFIG_DIR/hdfs-site.xml




echo '

# Set Hadoop-related environment variables
export HADOOP_PREFIX=/usr/local/hadoop
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_MAPRED_HOME=${HADOOP_HOME}
export HADOOP_COMMON_HOME=${HADOOP_HOME}
export HADOOP_HDFS_HOME=${HADOOP_HOME}
export YARN_HOME=${HADOOP_HOME}
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
# Native Path
export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native
export HADOOP_OPTS="-Djava.library.path=$HADOOP_PREFIX/lib"
#Java path
export JAVA_HOME='/usr/lib/jvm/java-8-oracle'
# Add Hadoop bin/ directory to PATH
export PATH=$PATH:$HADOOP_HOME/bin:$JAVA_PATH/bin:$HADOOP_HOME/sbin
' >> .bashrc


source .bashrc


hadoop namenode -format
hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode
yarn-daemon.sh start resourcemanager
yarn-daemon.sh start nodemanager
mr-jobhistory-daemon.sh start historyserver


sudo echo '#!/bin/sh
hadoop-daemon.sh start namenode
hadoop-daemon.sh start datanode
yarn-daemon.sh start resourcemanager
yarn-daemon.sh start nodemanager
mr-jobhistory-daemon.sh start historyserver
' > /bin/hadoop-all-start

sudo chmod +x /bin/hadoop-all-start








echo 'Install Scala'

wget http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz
sudo mkdir /usr/local/src/scala
sudo tar xvf scala-2.11.8.tgz -C /usr/local/src/scala/



echo '

export SCALA_HOME=/usr/local/src/scala/scala-2.11.8
export PATH=$SCALA_HOME/bin:$PATH
' >> .bashrc

source .bashrc

