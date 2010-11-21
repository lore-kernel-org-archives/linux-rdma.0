From: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Q] I tried to mount nfs_server:/mnt volume, but It mounted another volume.
Date: Sun, 21 Nov 2010 21:23:31 +0900
Message-ID: <AANLkTi=vpRm3MEiQZ39bw5XwfjL6CVbGEkAKWz-ynEp_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello lists

OS: CentOS 5.5
kernel: 2.6.36 rebuild myself.


  I'm trying to test NFS/RDMA.
  I tried to mount nfs_server:/mnt volume on on nfs_client
  but It mounted nfs_server:/nfstest volume

  note: /nfstest is tmpfs

 this is mount output
    tmpfs on /nfstest type tmpfs (rw,size=4g)
    /dev/sdb1 on /mnt type ext3 (rw)

  Is this bug??

NFS server config

  # ls -1 /mnt
  This_is_mnt_volume

  # ls -1 /nfstest
  This_is_nfstest_volume

  # cat /etc/exports
  /nfstest   192.168.100.0/255.255.255.0(fsid=0,rw,async,insecure,no_root_squash)
  /mnt       192.168.100.0/255.255.255.0(fsid=0,rw,async,insecure,no_root_squash)


  # modprobe svcrdma

  # /sbin/service nfs start

  # echo rdma 20049 > /proc/fs/nfsd/portlist


Client Setting

  /sbin/modprobe xprtrdma
  /sbin/mount.rnfs 192.168.100.231:/mnt /mnt -i -o rdma,port=20049

  # ls -1 /mnt
  This_is_nfstest_volume

NFS Server log
  sysctl -w sunrpc.nfsd_debug=1023

  Nov 21 20:47:37 dell1435 mountd[3575]: authenticated mount request
from 192.168.100.232:766 for /mnt (/mnt)
  Nov 21 20:47:37 dell1435 mountd[3575]: /nfstest and /mnt have same
filehandle for 192.168.100.0/255.255.255.0, using first
  Nov 21 20:48:55 dell1435 mountd[3575]: authenticated unmount request
from 192.168.100.232:912 for /mnt (/mnt)
  Nov 21 20:48:55 dell1435 mountd[3575]: authenticated unmount request
from 192.168.100.232:913 for /mnt (/mnt)
  Nov 21 20:49:00 dell1435 mountd[3575]: authenticated unmount request
from 192.168.100.232:917 for /mnt (/mnt)
  Nov 21 20:49:16 dell1435 mountd[3575]: authenticated mount request
from 192.168.100.232:865 for /mnt (/mnt)
  Nov 21 21:02:22 dell1435 mountd[3575]: authenticated unmount request
from 192.168.100.232:955 for /mnt (/mnt)
  Nov 21 21:02:26 dell1435 mountd[3575]: authenticated mount request
from 192.168.100.232:884 for /mnt (/mnt)
  Nov 21 21:02:26 dell1435 kernel: nfsd: exp_rootfh(/mnt
[ffff88011f586740] 192.168.100.0/255.255.255.0:sdb1/2)


--
Hiroyuki Sato
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
