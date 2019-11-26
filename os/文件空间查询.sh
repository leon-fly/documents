target_dirs=`ls -l|grep ^d|awk '{print $9}'`;
echo $target_dirs;
for chosed_dir in $target_dirs;
    do du -h $chosed_dir;
done;