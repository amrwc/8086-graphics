del uodos.img
bximage -mode=create -hd=10 -imgmode=flat -q uodos.img 
imdisk -a -t file -f uodos.img -p "/fs:fat /q /y" -m z:
imdisk -D -m z:
