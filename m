From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/5] Common systemd/udev based boot support
Date: Tue, 25 Jul 2017 13:49:37 -0500
Message-ID: <011601d30576$c3ac38c0$4b04aa40$@opengridcomputing.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com> <00e601d30562$f5a7dff0$e0f79fd0$@opengridcomputing.com> <20170725164004.GA20959@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170725164004.GA20959-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Leon Romanovsky' <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, 'Ira Weiny' <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Benjamin Drung' <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, 'Jarod Wilson' <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> For iwarp I expect that systemd will auto start these units:
> 
>   rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org  loaded active     exited    Load RDMA
> modules from /etc/rdma/modules/iwpmd.conf
>   rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org   loaded active     exited    Load RDMA
modules
> from /etc/rdma/modules/rdma.conf
>   rdma-load-modules-mPXOxrv7gkYc5CkaFG5UGg@public.gmane.org  loaded active     exited    Load RDMA
modules
> from /etc/rdma/modules/iwarp.conf
>   iwpmd.service                    loaded active     running   iWarp Port
Mapper
> 

After I rebooted, cxgb4 and iw_cxgb4 were loaded, but the services were not
started.  I think that is probably due to the fact that iw_cxgb4 doesn't
register with the rdma core until the cxgb4 interfaces are brought up.    I then
brought up port 0 of the cxgb4 card:

[root@stevo3 ~]# ip link set enp4s0f4 up
[root@stevo3 ~]# ip addr add 172.16.3.3/24 dev enp4s0f4

And then the services were started:

[root@stevo3 ~]# systemctl status rdma-load-modules-mPXOxrv7gkYc5CkaFG5UGg@public.gmane.org
â rdma-load-modules-mPXOxrv7gkYc5CkaFG5UGg@public.gmane.org - Load RDMA modules from
/etc/rdma/modules/iwarp.conf
   Loaded: loaded (/usr/lib/systemd/system/rdma-load-modules@.service; static;
vendor preset: disabled)
   Active: active (exited) since Tue 2017-07-25 11:43:21 PDT; 5s ago
  Process: 2571 ExecStart=/lib/systemd/systemd-modules-load
/etc/rdma/modules/%I.conf (code=exited, status=0/SUCCESS)
 Main PID: 2571 (code=exited, status=0/SUCCESS)

Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting Load RDMA modules
from /etc/rdma/modules/iwarp.conf...
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Started Load RDMA modules
from /etc/rdma/modules/iwarp.conf.
[root@stevo3 ~]# systemctl status rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org
â rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org - Load RDMA modules from
/etc/rdma/modules/rdma.conf
   Loaded: loaded (/usr/lib/systemd/system/rdma-load-modules@.service; static;
vendor preset: disabled)
   Active: active (exited) since Tue 2017-07-25 11:43:21 PDT; 10s ago
  Process: 2572 ExecStart=/lib/systemd/systemd-modules-load
/etc/rdma/modules/%I.conf (code=exited, status=0/SUCCESS)
 Main PID: 2572 (code=exited, status=0/SUCCESS)

Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting Load RDMA modules
from /etc/rdma/modules/rdma.conf...
Jul 25 11:43:21 stevo3.asicdesigners.com systemd-modules-load[2572]: Inserted
module 'ib_iser'
Jul 25 11:43:21 stevo3.asicdesigners.com systemd-modules-load[2572]: Inserted
module 'ib_uverbs'
Jul 25 11:43:21 stevo3.asicdesigners.com systemd-modules-load[2572]: Inserted
module 'rdma_ucm'
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Started Load RDMA modules
from /etc/rdma/modules/rdma.conf.
[root@stevo3 ~]# systemctl status rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org
â rdma-load-modules-r79FGtN6zq8c5CkaFG5UGg@public.gmane.org - Load RDMA modules from
/etc/rdma/modules/iwpmd.conf
   Loaded: loaded (/usr/lib/systemd/system/rdma-load-modules@.service; static;
vendor preset: disabled)
   Active: active (exited) since Tue 2017-07-25 11:43:21 PDT; 17s ago
  Process: 2573 ExecStart=/lib/systemd/systemd-modules-load
/etc/rdma/modules/%I.conf (code=exited, status=0/SUCCESS)
 Main PID: 2573 (code=exited, status=0/SUCCESS)

Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Starting Load RDMA modules
from /etc/rdma/modules/iwpmd.conf...
Jul 25 11:43:21 stevo3.asicdesigners.com systemd[1]: Started Load RDMA modules
from /etc/rdma/modules/iwpmd.conf.

And iwpmd is running:

[root@stevo3 ~]# pgrep iwpmd
2583

> And you should have a reasonable set of modules loaded. Check the
> journal for interesting errors also..
> 

[root@stevo3 ~]# lsmod|egrep "ib_|rdma"
rpcrdma                94208  0
rdma_ucm               24576  0
ib_uverbs              61440  1 rdma_ucm
ib_iser                49152  0
rdma_cm                53248  3 ib_iser,rpcrdma,rdma_ucm
ib_cm                  45056  1 rdma_cm
libiscsi               57344  1 ib_iser
iw_cm                  45056  1 rdma_cm
scsi_transport_iscsi    98304  2 ib_iser,libiscsi
ib_core               208896  9
ib_iser,ib_cm,rdma_cm,iw_cxgb4,ib_uverbs,rpcrdma,iw_cm,rdma_ucm
sunrpc                348160  8 auth_rpcgss,nfsd,rpcrdma,nfs_acl,lockd

> For cxgb4 these are the two critical udev lines:
> 
> ENV{ID_NET_DRIVER}=="cxgb4", RUN{builtin}+="kmod load iw_cxgb4"
> DRIVERS=="cxgb4", ENV{ID_RDMA_IWARP}="1"
> 
> The first should load iw_cxgb4 if an ethernet device with the cxgb4
> driver is found (the driver name being matched is as reported by
> ethtool -i)

I assume since iw_cxgb4 was loaded, that they worked.  Because before I
installed rdma-core, after a reboot only cxgb4 was loaded.

> 
> Both need to trigger for things to work properly, you can check with:
> 
> $ udevadm info /sys/class/net/ethX
> $ udevadm info /sys/class/infiniband/cxgb4_0 # ??
> 

How does this look?

[root@stevo3 ~]# udevadm info /sys/class/net/enp4s0f4
P: /devices/pci0000:00/0000:00:02.0/0000:04:00.4/net/enp4s0f4
E: DEVPATH=/devices/pci0000:00/0000:00:02.0/0000:04:00.4/net/enp4s0f4
E: ID_BUS=pci
E: ID_MM_CANDIDATE=1
E: ID_MODEL_FROM_DATABASE=T520-LL-CR Unified Wire Ethernet Controller
E: ID_MODEL_ID=0x5411
E: ID_NET_DRIVER=cxgb4
E: ID_NET_NAME_MAC=enx000743292f20
E: ID_NET_NAME_PATH=enp4s0f4
E: ID_OUI_FROM_DATABASE=Chelsio Communications
E: ID_PATH=pci-0000:04:00.4
E: ID_PATH_TAG=pci-0000_04_00_4
E: ID_PCI_CLASS_FROM_DATABASE=Network controller
E: ID_PCI_SUBCLASS_FROM_DATABASE=Ethernet controller
E: ID_VENDOR_FROM_DATABASE=Chelsio Communications Inc
E: ID_VENDOR_ID=0x1425
E: IFINDEX=6
E: INTERFACE=enp4s0f4
E: MAJOR=0
E: MINOR=0
E: SUBSYSTEM=net
E: SYSTEMD_ALIAS=/sys/subsystem/net/devices/enp4s0f4
/sys/subsystem/net/devices/enp4s0f4
E: TAGS=:systemd:
E: USEC_INITIALIZED=68132

[root@stevo3 ~]# udevadm info /sys/class/infiniband/cxgb4_0 #??
P: /devices/pci0000:00/0000:00:02.0/0000:04:00.4/infiniband/cxgb4_0
E: DEVPATH=/devices/pci0000:00/0000:00:02.0/0000:04:00.4/infiniband/cxgb4_0
E: ID_BUS=pci
E: ID_MODEL_FROM_DATABASE=T520-LL-CR Unified Wire Ethernet Controller
E: ID_MODEL_ID=0x5411
E: ID_PCI_CLASS_FROM_DATABASE=Network controller
E: ID_PCI_SUBCLASS_FROM_DATABASE=Ethernet controller
E: ID_RDMA_IWARP=1
E: ID_VENDOR_FROM_DATABASE=Chelsio Communications Inc
E: ID_VENDOR_ID=0x1425
E: NAME=cxgb4_0
E: SUBSYSTEM=infiniband
E: SYSTEMD_WANTS=rdma-ndd.service iwpmd.service rdma-load-modules-XSrBNAzizW1TDjBF/Jpztg@public.gmane.org
rdma-load-modules-mPXOxrv7gkYc5CkaFG5UGg@public.gmane.org
E: TAGS=:systemd:
E: USEC_INITIALIZED=428610768


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
