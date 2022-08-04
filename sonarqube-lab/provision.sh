#/usr/bin/bash

useradd sonar
yum install wget unzip java-11-openjdk-devel -y
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.5.0.56709.zip
unzip sonarqube-9.5.0.56709.zip -d /opt/
mv /opt/sonarqube-9.5.0.56709 /opt/sonarqube
#passando a permissão para sonar openar em sonarqube
chown -R sonar:sonar /opt/sonarqube
#criando e despois zerando o sonar.service
touch /etc/systemd/system/sonar.service
echo > /etc/systemd/system/sonar.service
#o cat deste eot para dentro do arquivo sonar.service
cat <<EOT >> /etc/systemd/system/sonar.service
[Unit]
Description=Sonarqube service
After=syslog.target network.target
[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
[Install]
WantedBy=multi-user.target
EOT
service sonar start

#instalar o sonar scaner

wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip
unzip sonar-scanner-cli-4.7.0.2747-linux.zip -d /opt/
mv /opt/sonar-scanner-cli-4.7.0.2747-linux /opt/sonar-scanner
chown -R sonar:sonar /opt/sonar-scanner
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install nodejs -y

##finalizando a instalação insira os códigoas a baixo no centos, para retirar o erro da versao 10
#sudo yum clean all && sudo yum makecache fast
#sudo yum install -y gcc-c++ make
#sudo yum install -y nodejs
#token do sonarqube
#Analyze "node-app1": sqp_ac2a64dc860228431bbd0c2e790a329e48a123e0