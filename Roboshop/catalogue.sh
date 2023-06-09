script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
component=catalogue
rm -rf log_path
print_head "<<<Setup Node JS>>>>"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>log_path
fun_stat_check $?
print_head "<<<install nodejs>>>"
yum install nodejs -y &>>log_path &>>log_path
fun_stat_check $?
print_head "<<<Add application user roboshop>>>"
useradd roboshop &>>log_path
print_head "remove /app dir"
rm -rf /app &>>log_path
fun_stat_check $?
print_head "Create app dir"
mkdir /app &>>log_path
fun_stat_check $?
print_head "download application content"
curl -L -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>log_path
cd /app
unzip /tmp/$component.zip &>>log_path
fun_stat_check $?
print_head  "install dependencies"
npm install &>>log_path
fun_stat_check $?
print_head "copy mongo repo file"
cp $script_path/mongo.repo /etc/yum.repos.d/mongodb.repo &>>log_path
fun_stat_check $?
print_head "install mongodb"
yum install mongodb-org-shell -y &>>log_path
fun_stat_check $?
print_head "load schema"
mongo --host mongodb-dev.rtdevopspract.online </app/schema/$component.js &>>log_path
fun_stat_check $?
print_head "copy catologue service"
cp $script_path/$component.service /etc/systemd/system/$component.service &>>log_path
fun_stat_check $?
print_head  "load catalogue service"
systemctl daemon-reload &>>log_path
systemctl enable $component &>>log_path
systemctl restart $component &>>$log_path
fun_stat_check $?
