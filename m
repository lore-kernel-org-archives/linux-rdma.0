From: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH qedr 00/10] QLogic RDMA Driver (qedr)
Date: Wed, 5 Oct 2016 18:47:53 +0300
Message-ID: <1475682483-9878-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This series introduces RoCE RDMA driver for the 579xx RDMA products by
Qlogic. The RDMA support is added as an additional loadable module (qedr)
over the Ethernet qede driver.
The qedr module will support both RoCE and iWarp, although this series
only adds RoCE support.

This series was preceded by RFC v3[1].The major difference between the two
is that the required qed and qede driver changes for RDMA support were 
already submitted and accepted on net-next by Dave for 4.9, see [2]. Also,
the qedr menu configuration was moved from net/ethernet to infiniband.

The series was built and tested against branch k.o/for-4.9, based on:
7958b377d0c961881471c224da9f3a3 (after importing qed/qede patches, and
more, from net-dev).

Thanks for everyone which pointed out problems in the driver.

Reference:
 - [1] http://www.spinics.net/lists/linux-rdma/msg41087.html
 - [2] https://www.spinics.net/lists/netdev/msg398562.html

Rajesh Borundia (10):
  qedr: Add RoCE driver framework
  qedr: Add support for RoCE HW init
  qedr: Add support for user context verbs
  qedr: Add support for PD,PKEY and CQ verbs
  qedr: Add support for QP verbs
  qedr: Add support for memory registeration verbs
  qedr: Add support for data path
  qedr: Add LL2 RoCE interface
  qedr: Add GSI support
  qedr: Add events support and register IB device

 drivers/infiniband/Kconfig                 |    2 +
 drivers/infiniband/hw/Makefile             |    1 +
 drivers/infiniband/hw/qedr/Kconfig         |    7 +
 drivers/infiniband/hw/qedr/Makefile        |    3 +
 drivers/infiniband/hw/qedr/main.c          |  911 +++++++
 drivers/infiniband/hw/qedr/qedr.h          |  495 ++++
 drivers/infiniband/hw/qedr/qedr_cm.c       |  636 +++++
 drivers/infiniband/hw/qedr/qedr_cm.h       |   61 +
 drivers/infiniband/hw/qedr/qedr_hsi.h      |   56 +
 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h |  748 ++++++
 drivers/infiniband/hw/qedr/verbs.c         | 3552 ++++++++++++++++++++++++++++
 drivers/infiniband/hw/qedr/verbs.h         |  101 +
 drivers/net/ethernet/qlogic/Kconfig        |   11 -
 include/uapi/linux/pci_regs.h              |    3 +
 include/uapi/rdma/qedr-abi.h               |  106 +
 15 files changed, 6682 insertions(+), 11 deletions(-)
 create mode 100644 drivers/infiniband/hw/qedr/Kconfig
 create mode 100644 drivers/infiniband/hw/qedr/Makefile
 create mode 100644 drivers/infiniband/hw/qedr/main.c
 create mode 100644 drivers/infiniband/hw/qedr/qedr.h
 create mode 100644 drivers/infiniband/hw/qedr/qedr_cm.c
 create mode 100644 drivers/infiniband/hw/qedr/qedr_cm.h
 create mode 100644 drivers/infiniband/hw/qedr/qedr_hsi.h
 create mode 100644 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h
 create mode 100644 drivers/infiniband/hw/qedr/verbs.c
 create mode 100644 drivers/infiniband/hw/qedr/verbs.h
 create mode 100644 include/uapi/rdma/qedr-abi.h

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
