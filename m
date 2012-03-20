From: <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/9] ocrdma: Driver for Emulex OneConnect RDMA
Date: Wed, 21 Mar 2012 04:09:05 +0530
Message-ID: <cdc8267d-7cc4-4364-ade7-0b10f02a7c49@exht1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Emulex One Connect Adapter is RDMA (RoCE) capable multi-function
PCI Express device.
This driver patch enables RoCE support on such adapter.

This ocrdma driver depends on be2net NIC driver.
This patch depends on the previously submitted be2net NIC driver patch.

Code organization:
- ocrdma.h       : driver header file.
- ocrdma_main.c  : driver registration with stack.
- ocrdma_sli.h   : driver-adapter interface definitions.
- ocrdma_hw.*    : hardware specific initialization, mailbox cmds.
- ocrdma_verbs.* : verbs interface functionality.
- ocrdma_ah.*    : address handle related functionaliy.
- ocrdma_abi.h   : user space library interaction definitions.

This patch is made against the current git tree.
Please provide your review comments.

I have resent this patch as previous bigger patch was dropped by vger.kernel.org.
Thank you.

Parav Pandit (9):
  ocrdma: Driver for Emulex OneConnect RDMA adapter
  ocrdma: Driver for Emulex OneConnect RDMA adapter
  ocrdma: Driver for Emulex OneConnect RDMA adapter
  ocrdma: Driver for Emulex OneConnect RDMA adapter
  ocrdma: Driver for Emulex OneConnect RDMA adapter
  ocrdma: Driver for Emulex OneConnect RDMA adapter
  ocrdma: Driver for Emulex OneConnect RDMA adapter
  ocrdma: Driver for Emulex OneConnect RDMA adapter
  ocrdma: Driver for Emulex OneConnect RDMA adapter

 drivers/infiniband/Kconfig                  |    1 +
 drivers/infiniband/Makefile                 |    1 +
 drivers/infiniband/hw/ocrdma/Kconfig        |    8 +
 drivers/infiniband/hw/ocrdma/Makefile       |    5 +
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  392 ++++
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h   |  134 ++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |  172 ++
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h    |   42 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 2640 +++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |  132 ++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |  558 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   | 1672 +++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2542 ++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h |   94 +
 14 files changed, 8393 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/hw/ocrdma/Kconfig
 create mode 100644 drivers/infiniband/hw/ocrdma/Makefile
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_abi.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_ah.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_ah.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_hw.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_hw.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_main.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_sli.h
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
