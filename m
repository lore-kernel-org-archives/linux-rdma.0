From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/7] Add RSS/TSS QP groups and IPoIB support for RSS/TSS
Date: Tue,  8 May 2012 19:22:24 +0300
Message-ID: <1336494151-31050-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, so...

RSS (Receive Side Scaling) TSS (Transmit Side Scaling, better known as
MQ/Multi-Queue) are common networking techniques which allow to use
contemporary NICs that support multiple receive and transmit descriptor
queues (multi-queue), see also Documentation/networking/scaling.txt

This series introduces the concept of RSS and TSS QP groups which
allows for implementing them by low level drivers and using them
by IPoIB and later also by user space ULPs. An implementation 
for the mlx4_ib driver is provided.

Next, the IPoIB code is modified to support RSS/TSS, this is done in two steps.

The first step is a vectorization restructure as pre-step for TSS/RSS
such that the driver becomes multi-ring one, using multiple RX/TX rings.

The second step makes use of the QP groups concept to enable RSS
and TSS.

The patch series is built as following

1/7 net/mlx4: add new cap flags field to track more capabilities
2/7 IB/mlx4: replace KERN_yyy printk calls with pr_yyy ones
3/7 IB/mlx4: increase the number of vectors (EQs) available for ULPs

are infra-structure changes in the mlx4 driver used later to support TSS/RSS
they were already submitted ten days ago, but added here for clarity 
and ease of review.

4/7 IB/core: Add RSS and TSS QP groups

is the IB core patch that introduces QP groups

5/7 IB/mlx4: Add support for RSS and TSS QP groups

is the mlx4 driver implementation for QP groups and TSS/RSS

6/7 IB/ipoib: Implement vectorization restructure as pre-step for TSS/RSS

is the vectorization restructure, pre-step for TSS/RSS

7/7 IB/ipoib: Add RSS and TSS support for datagram mode

enables TSS and RSS

Enjoy, 

Or.

Shlomo Pongratz (7):
  net/mlx4: add new cap flags field to track more capabilities
  IB/mlx4: replace KERN_yyy printk call with pr_yyy ones
  IB/mlx4: increase the number of vectors (EQs) available for ULPs
  IB/core: Add RSS and TSS QP groups
  IB/mlx4: Add support for RSS and TSS QP groups
  IB/ipoib: Implement vectorization restructure as pre-step for TSS/RSS
  IB/ipoib: Add RSS and TSS support for datagram mode

 drivers/infiniband/core/verbs.c                |    3 +
 drivers/infiniband/hw/amso1100/c2_provider.c   |    3 +
 drivers/infiniband/hw/cxgb3/iwch_provider.c    |    2 +
 drivers/infiniband/hw/cxgb4/qp.c               |    3 +
 drivers/infiniband/hw/ehca/ehca_qp.c           |    6 +
 drivers/infiniband/hw/ipath/ipath_qp.c         |    3 +
 drivers/infiniband/hw/mlx4/cq.c                |   13 +-
 drivers/infiniband/hw/mlx4/main.c              |  102 ++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h           |   15 +
 drivers/infiniband/hw/mlx4/mr.c                |    2 +-
 drivers/infiniband/hw/mlx4/qp.c                |  353 ++++++++++++-
 drivers/infiniband/hw/mlx4/srq.c               |    2 +-
 drivers/infiniband/hw/mthca/mthca_provider.c   |    3 +
 drivers/infiniband/hw/nes/nes_verbs.c          |    3 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c    |    5 +
 drivers/infiniband/hw/qib/qib_qp.c             |    5 +
 drivers/infiniband/ulp/ipoib/ipoib.h           |  100 +++-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c        |   97 +++--
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   |   92 +++-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c        |  552 ++++++++++++++------
 drivers/infiniband/ulp/ipoib/ipoib_main.c      |  363 ++++++++++++--
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c |   34 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c     |  660 +++++++++++++++++++++---
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c      |    2 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c        |   29 +
 drivers/net/ethernet/mellanox/mlx4/fw.h        |    2 +
 drivers/net/ethernet/mellanox/mlx4/main.c      |    2 +
 include/linux/mlx4/device.h                    |    8 +
 include/rdma/ib_verbs.h                        |   26 +-
 29 files changed, 2108 insertions(+), 382 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
