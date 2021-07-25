#!/bin/bash
a=()
b=()
j=0
cp default.conf nginx.conf
sed -i '$d' nginx.conf
sed -i '$d' nginx.conf
for line in `cat *.csv`
do 
#切割字符
    appname=`echo $line | cut -d \, -f 1`
    url=`echo $line | cut -d \, -f 2`
    helpurl=`echo $line | cut -d \, -f 3`
#检查是否重复

if [[ "${a[@]}" =~ "${url}" ]]
then
   echo "${appname}${url}不符合条件"
   j=$((j+1))
   b[${#b[*]}]=${appname}${url}
   continue
else
   echo -e "${url}符合条件"
#不重复则写入数组
    a[${#a[*]}]=${url}
#写入配置文件
	echo -e "\n" >> nginx.conf
	echo -e "# ${appname};" >> nginx.conf
	echo -e "location = ${url} { " >> nginx.conf
	echo -e "proxy_pass http://localhost${helpurl}" >> nginx.conf
	echo -e ";} " >> nginx.conf
	echo -e "\n" >> nginx.conf
fi
#打印所有元素
done
#for  ((i=0;i<${#a[*]};i++ ))
#do
#	echo ${a[i]}
#done
echo -e "}" >> nginx.conf
echo -e "}" >> nginx.conf
echo -e "congratulations! 配置文件生成成功！"
echo "合计${j}个重复URL,他们是${b[@]}"
cp nginx.conf /ES3016/conf/nginx.conf
cd /ES3016/sbin/
./nginx
./nginx -s reload