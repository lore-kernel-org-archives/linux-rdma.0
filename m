From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V2 0/4] Add driver for Cisco's VIC series adapters
Date: Tue, 10 Sep 2013 03:36:07 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013CF2ED@xmb-rcd-x09.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <111BD5CEE44A9846A247076525524518-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC is the kernel driver for userspace bypass networking on Cisco's
VIC series adapters.  usNIC devices are advertised as SRIOV VFs by the
VIC adapters and these VFs are owned by usNIC.  The driver works in
conjuction with Cisco's ethernet driver, which owns the PFs, and does
priviledged firmware operations via the PF driver.

The Cisco driver patches - driver part 1,2, 3 below - depend on the 
following patches - in order - in the net-next tree at 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git:
1) f13bbc2f9aba00c7a37b499d23060616b9a4ef9e
2) 92e2b4696202934b4cbf1d6b8fb8729e8d7202e1
3) 0b038566c0ea9f8daceae879bb7ad748ab8c95f0
4) d765bb41fde311b57de32bdc9d17965debe8b7af
5) 4a50ddfda72881d5d67a2b25f9b8a120b2765125

This patch is being partitioned to avoid 100KB vger.kernel.org
limitation.

Changes from previous V1:
- Added comment describing ABI
- Make event2str array const in *netdev_event_to_string
- Used ARRAY_SIZE instead of sizeof in *netdev_event_to_string
- Few white space changes
- Bug fix: Work queue is destroyed at module unload time

IB/core: Cisco VIC - usNIC rdma node and transport
IB/usnic: Cisco VIC - driver part 1/3
IB/usnic: Cisco VIC - driver part 2/3
IB/usnic: Cisco VIC - driver part 3/3

 drivers/infiniband/core/sysfs.c                    |    1 
 drivers/infiniband/core/verbs.c                    |    3 
 include/rdma/ib_verbs.h                            |    6 
 drivers/infiniband/hw/usnic/usnic_abi.h            |   56 ++
 drivers/infiniband/hw/usnic/usnic_ib.h             |  115 +++
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  598 ++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      |  541 +++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h      |   97 +++
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |  351 ++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.h       |   29 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  734 ++++++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |   72 ++
 drivers/infiniband/hw/usnic/usnic.h                |   29 +
 drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h |   27 +
 drivers/infiniband/hw/usnic/usnic_common_util.h    |   51 +
 drivers/infiniband/hw/usnic/usnic_debugfs.c        |   71 ++
 drivers/infiniband/hw/usnic/usnic_debugfs.h        |   25 +
 drivers/infiniband/hw/usnic/usnic_fwd.c            |  243 +++++++
 drivers/infiniband/hw/usnic/usnic_fwd.h            |   58 ++
 drivers/infiniband/hw/usnic/usnic_log.h            |   58 ++
 drivers/infiniband/hw/usnic/usnic_transport.c      |  125 +++
 drivers/infiniband/hw/usnic/usnic_transport.h      |   27 +
 drivers/infiniband/hw/usnic/usnic_uiom.c           |  599 ++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_uiom.h           |   80 ++
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.c |  237 ++++++
 .../infiniband/hw/usnic/usnic_uiom_interval_tree.h |   74 ++
 drivers/infiniband/hw/usnic/usnic_vnic.c           |  473 +++++++++++++
 drivers/infiniband/hw/usnic/usnic_vnic.h           |  105 +++
 MAINTAINERS                                        |    5 
 drivers/infiniband/Kconfig                         |    1 
 drivers/infiniband/Makefile                        |    1 
 drivers/infiniband/hw/usnic/Kconfig                |   11 
 drivers/infiniband/hw/usnic/Makefile               |   15 
 33 files changed, 4916 insertions(+), 2 deletions(-)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
