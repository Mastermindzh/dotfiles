alias vm='su -c "export QT_AUTO_SCREEN_SCALE_FACTOR= QT_SCREEN_SCALE_FACTORS= QT_SCALE_FACTOR= QT_DEVICE_PIXEL_RATIO= && VBoxManage setextradata Windows10 GUI/HiDPI/UnscaledOutput 1 && sudo VBoxManage startvm Windows10" && exit'
alias dock='bash ~/.docked.sh && i3-msg restart'
alias undock='bash ~/.undocked.sh && i3-msg restart'
alias mountdata='sudo cryptsetup open --type luks /dev/nvme0n1p7 data && sudo mount -t ext4 /dev/mapper/data /home/mastermindzh/data'
alias unmountdata='sudo umount /home/mastermindzh/data && sudo cryptsetup close data && sudo sysctl --write vm.drop_caches=3'

# useful kubernetes (AZURE) commands
alias kubernetes-qa='azkubeswitch Inforit.Cloud InforitCluster'
alias kubernetes-prod='azkubeswitch Inforit.Cloud Production'
alias kubernetes-dev='azkubeswitch Inforit.Cloud Development'
