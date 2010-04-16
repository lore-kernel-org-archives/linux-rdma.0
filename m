From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v3 00/10] iw_cxgb4 driver submission
Date: Fri, 16 Apr 2010 13:29:25 -0500
Message-ID: <20100416182924.22495.59421.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes since version 2 of this series:

- termination fixes

- peer2peer fixes

------

The following series adds the iw_cxgb4 rdma driver for Chelsio's new
1G and 10G T4 adapters.   Please review and provide comments, and
I'll repost an updated patch series as I incorporate your feedback.

This series depends on the cxgb4 driver recently merged into:

git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git

You can find the final cxgb4 patch submission at:

http://www.spinics.net/lists/netdev/msg125898.html

The iw_cxgb4 patches are against the above net-2.6 tree as of cf16d7d.
You can also pull these from:

git://www.openfabrics.org/~swise/cxgb4.git iw_cxgb4

 drivers/infiniband/Kconfig                |    1 
 drivers/infiniband/Makefile               |    1 
 drivers/infiniband/hw/cxgb4/Kconfig       |   19 
 drivers/infiniband/hw/cxgb4/Makefile      |    5 
 drivers/infiniband/hw/cxgb4/cm.c          | 2348 +++++++++++++++++++++++++++++
 drivers/infiniband/hw/cxgb4/cq.c          |  882 +++++++++++
 drivers/infiniband/hw/cxgb4/device.c      |  520 ++++++
 drivers/infiniband/hw/cxgb4/ev.c          |  193 ++
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h    |  743 +++++++++
 drivers/infiniband/hw/cxgb4/mem.c         |  811 ++++++++++
 drivers/infiniband/hw/cxgb4/provider.c    |  518 ++++++
 drivers/infiniband/hw/cxgb4/qp.c          | 1575 +++++++++++++++++++
 drivers/infiniband/hw/cxgb4/resource.c    |  417 +++++
 drivers/infiniband/hw/cxgb4/t4.h          |  536 +++++++
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |  829 ++++++++++
 drivers/infiniband/hw/cxgb4/user.h        |   66 +
 16 files changed, 9464 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/cxgb4/Kconfig
 create mode 100644 drivers/infiniband/hw/cxgb4/Makefile
 create mode 100644 drivers/infiniband/hw/cxgb4/cm.c
 create mode 100644 drivers/infiniband/hw/cxgb4/cq.c
 create mode 100644 drivers/infiniband/hw/cxgb4/device.c
 create mode 100644 drivers/infiniband/hw/cxgb4/ev.c
 create mode 100644 drivers/infiniband/hw/cxgb4/iw_cxgb4.h
 create mode 100644 drivers/infiniband/hw/cxgb4/mem.c
 create mode 100644 drivers/infiniband/hw/cxgb4/provider.c
 create mode 100644 drivers/infiniband/hw/cxgb4/qp.c
 create mode 100644 drivers/infiniband/hw/cxgb4/resource.c
 create mode 100644 drivers/infiniband/hw/cxgb4/t4.h
 create mode 100644 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
 create mode 100644 drivers/infiniband/hw/cxgb4/user.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
