From: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Mellanox CX5 Not Showing Up In ibv_devices (on some systems)
Date: Thu, 26 Oct 2017 16:49:29 +0000
Message-ID: <DE927C68B458BE418D582EC97927A9287FD16661@ORSMSX113.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, I'm having trouble with ibv_devices (and related tools like ibv_devinfo, ib_send_bw, etc) not recognizing my Mellanox CX5 NICs in some systems.  The NICs work fine for TCP/IP traffic, and I think for RDMA traffic as well as I can do NVMeoF discovery and make NVMeoF connections, but they're just not listed in ibv_devices.

I have some other systems with a similar setup which work fine and I can't see what's making the difference between the two setups.  We're running an Ubuntu OS with recent kernel (this has been seen with 4.12.10 and 4.13.9).  Can anyone provide some guidance on what might cause this problem and how to fix it?

Here's the failing example:

intel@BigTwin-A:~$ uname -a
Linux BigTwin-A 4.12.10-041210-generic #201708300614 SMP Wed Aug 30 10:16:40 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

intel@BigTwin-A:~$ sudo lspci -v|egrep 'Mel|mlx'
18:00.0 Ethernet controller: Mellanox Technologies MT28800 Family [ConnectX-5]
        Subsystem: Mellanox Technologies MT28800 Family [ConnectX-5]
        Kernel driver in use: mlx5_core
        Kernel modules: mlx5_core

intel@BigTwin-A:~$ sudo lsmod|egrep 'mlx|ib_|rdma'
ib_iser                49152  0
libiscsi               53248  3 ib_iser,libiscsi_tcp,iscsi_tcp
scsi_transport_iscsi    94208  4 ib_iser,libiscsi,iscsi_tcp
nvmet_rdma             24576  0
nvmet                  49152  1 nvmet_rdma
nvme_rdma              28672  0
nvme_fabrics           20480  1 nvme_rdma
rdmavt                 69632  0
rdma_ucm               28672  0
rdma_cm                57344  4 ib_iser,nvme_rdma,rdma_ucm,nvmet_rdma
iw_cm                  45056  1 rdma_cm
ib_cm                  53248  1 rdma_cm
ib_uverbs              69632  1 rdma_ucm
mlx5_ib               176128  0
ib_core               204800  10 ib_iser,ib_cm,rdma_cm,nvme_rdma,ib_uverbs,iw_cm,mlx5_ib,rdmavt,rdma_ucm,nvmet_rdma
mlx5_core             413696  1 mlx5_ib
devlink                40960  1 mlx5_core
ptp                    20480  2 ixgbe,mlx5_core
nvme_core              61440  5 nvme_fabrics,nvme_rdma,nvme

intel@BigTwin-A:~$ sudo ibv_devices
libibverbs: Warning: no userspace device-specific driver found for /sys/class/infiniband_verbs/uverbs0
    device                 node GUID
    ------              ----------------


A working example from a different system:

nvmf@nvmfji03:~$ uname -a
Linux nvmfji03 4.12.10-041210-generic #201708300614 SMP Wed Aug 30 10:16:40 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

nvmf@nvmfji03:~$ sudo lspci -v|egrep 'Mel|mlx'
81:00.0 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
        Subsystem: Mellanox Technologies MT27800 Family [ConnectX-5]
        Kernel driver in use: mlx5_core
        Kernel modules: mlx5_core
81:00.1 Ethernet controller: Mellanox Technologies MT27800 Family [ConnectX-5]
        Subsystem: Mellanox Technologies MT27800 Family [ConnectX-5]
        Kernel driver in use: mlx5_core
        Kernel modules: mlx5_core

nvmf@nvmfji03:~$ sudo lsmod|egrep 'mlx|ib_|rdma'
ib_iser                49152  0
libiscsi               53248  3 ib_iser,libiscsi_tcp,iscsi_tcp
scsi_transport_iscsi    94208  4 ib_iser,libiscsi,iscsi_tcp
nvmet_rdma             24576  0
nvmet                  49152  1 nvmet_rdma
nvme_rdma              28672  0
nvme_fabrics           20480  1 nvme_rdma
nvme_core              61440  2 nvme_fabrics,nvme_rdma
rdmavt                 69632  0
rdma_ucm               28672  0
rdma_cm                57344  4 ib_iser,nvme_rdma,rdma_ucm,nvmet_rdma
iw_cm                  45056  1 rdma_cm
ib_cm                  53248  1 rdma_cm
ib_uverbs              69632  1 rdma_ucm
mlx5_ib               176128  0
ib_core               204800  10 ib_iser,ib_cm,rdma_cm,nvme_rdma,ib_uverbs,iw_cm,mlx5_ib,rdmavt,rdma_ucm,nvmet_rdm
mlx5_core             413696  1 mlx5_ib
devlink                40960  1 mlx5_core
ptp                    20480  2 igb,mlx5_core

nvmf@nvmfji03:~$ sudo ibv_devices
    device                 node GUID
    ------              ----------------
    mlx5_1              248a070300a43add
    mlx5_0              248a070300a43adc


Thanks,
Joe
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
