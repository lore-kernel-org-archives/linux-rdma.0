From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 00/17] ocrdma driver code sync-up
Date: Tue, 4 Feb 2014 11:56:53 +0530
Message-ID: <efde0f4e-f596-4817-a356-e38b76f0c8b8@CMEXHTCAS2.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series contains bug fixes ocrdma driver. Also
added routines for retrieving controller information
and statistics from the hardware.

Please apply the patch series to for-next tree.

Devesh Sharma (9):
  RDMA/ocrdma: Eq full catastrophe avoidance
  RDMA/ocrdma: SQ and RQ doorbell offset clean up
  RDMA/ocrdma: read ASIC_ID register to select asic_gen
  RDMA/ocrdma: Allow DPP QP creation
  RDMA/ocrdma: ABI versioning between ocrdma and be2net
  be2net: adding abi version between be2net and ocrdma
  RDMA/ocrdma: update version string
  RDMA/ocrdma: increment abi version count
  RDMA/ocrdma: code clean-up

Selvin Xavier (8):
  RDMA/ocrdma: Memory leak fix in ocrdma_dereg_mr
  RDMA/ocrdma: Use non zero tag in SRQ posting
  RDMA/ocrdma: Display proper value for max_mw
  RDMA/ocrdma: Handle CQ overrun error
  RDMA/ocrdma: Support non-embedded mailbox commands
  RDMA/ocrdma: Query controller information
  RDMA/ocrdma: Support for Skyhawk statistics
  RDMA/ocrdma: Display fw version

 drivers/infiniband/hw/ocrdma/Makefile       |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  110 ++++-
 drivers/infiniband/hw/ocrdma/ocrdma_abi.h   |    7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  291 ++++++++++---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |    3 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   65 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  261 +++++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  623 +++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h |   54 +++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  163 ++++---
 drivers/net/ethernet/emulex/benet/be_roce.c |    6 +
 drivers/net/ethernet/emulex/benet/be_roce.h |    3 +
 13 files changed, 1434 insertions(+), 156 deletions(-)
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_stats.c
 create mode 100644 drivers/infiniband/hw/ocrdma/ocrdma_stats.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
