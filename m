From: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: How to tell RoCE v1 vs v2?
Date: Fri, 2 Feb 2018 19:19:10 +0000
Message-ID: <DE927C68B458BE418D582EC97927A9287FE1FCF7@ORSMSX113.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi folks-

We're doing some NVMeoF testing.  We have Xeon servers with Mellanox CX4 NICs connected through an Arista 7060CX switch.  We're using the kernel support for RDMA and NVMeoF in Ubuntu 16.10 with a 4.12.5 kernel.  I'm trying to figure out if we're running RoCE v1 or RoCE v2.  I can't seem to Google up a way to check when running the kernel solution, just answers for Mellanox OFED.  Is there a way to tell?  And if we're running v1, is there a way to force v2?

Thanks!  Some system details below if they're at all helpful.

root@purley01:/home/rsa# cat /etc/os-release
NAME="Ubuntu"
VERSION="16.10 (Yakkety Yak)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 16.10"
VERSION_ID="16.10"
HOME_URL="http://www.ubuntu.com/"
SUPPORT_URL="http://help.ubuntu.com/"
BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="http://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=yakkety
UBUNTU_CODENAME=yakkety

root@purley01:/home/rsa# uname -a
Linux purley01 4.12.5-041205-generic #201708061334 SMP Sun Aug 6 17:35:26 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

root@purley01:/home/rsa# lsmod|egrep 'mlx|nvm|ib'
nvmet_rdma             24576  0
nvmet                  49152  1 nvmet_rdma
nvme_rdma              28672  0
nvme_fabrics           20480  1 nvme_rdma
rdma_cm                57344  3 nvme_rdma,rdma_ucm,nvmet_rdma
ib_cm                  49152  1 rdma_cm
ib_uverbs              69632  1 rdma_ucm
mlx5_ib               180224  0
ib_core               204800  9 ib_cm,rdma_cm,nvme_rdma,ib_uverbs,iw_cm,mlx5_ib,rdmavt,rdma_ucm,nvmet_rdma
mlx5_core             413696  1 mlx5_ib
devlink                40960  1 mlx5_core
ptp                    20480  2 igb,mlx5_core
nvme                   28672  4
nvme_core              61440  8 nvme_fabrics,nvme_rdma,nvme
libahci                32768  1 ahci
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
