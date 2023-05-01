script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
component=mysql
mysql_root_password=$1
if [ -z "$mysql_root_password" ]; then
  echo Input MySQL Root Password Missing
  exit
fi
print_head "Disable MySQL 8 Version"
dnf module disable mysql -y &>>$log_path
func_stat_check $?
print_head "copy mysql repo file"
cp $script_path/$component.repo /etc/yum.repos.d/$component.repo &>>log_path
func_stat_check $?
print_head "install mysql"
yum install mysql-community-server -y &>>$log_path
func_stat_check $?
print_head "Start MySQL"
systemctl enable mysqld &>>$log_path
systemctl restart mysqld &>>$log_path
func_stat_check $?
print_head "Reset MySQL Password"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_stat_check $?