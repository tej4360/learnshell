source /learnshell/Roboshop/common.sh
rm -rf /app/roboshop_log
print_head "<<<Setuop Node JS>>>>"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/app/roboshop_log
print_head "<<<install nodejs>>>"

yum install nodejs -y &>>/app/roboshop_log
print_head "<<<Add application user roboshop>>>"
useradd roboshop &>>/app/roboshop_log
rm -rf /app
print_head "Create app dir"
mkdir /app
print_head "download application content"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
print_head  "install dependencies"
npm install &>>/app/roboshop_log
cd /learnshell
print_head "copy catologue service"
cp Roboshop/catalogue.service /etc/systemd/system/catalogue.service
print_head  "load catalogue service"
print_head "install mongo"
cp Roboshop/mongo.repo /etc/yum.repos.d/mongodb.repo
yum install mongodb-org-shell -y
print_head "load schema"
mongo --host mongo.rtdevopspract.online </app/schema/catalogue.js
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
