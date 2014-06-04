From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 00/15] Bug fixes for ocrdma driver
Date: Wed, 4 Jun 2014 23:49:00 +0530
Message-ID: <173b8ab5-c894-4c83-83a8-1fdd447e81a4@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch series contains bug fixes for ocrdma driver.
Correcting the truncated subject line of some patches and resending the patch series.

Please apply to for-next tree.

Devesh Sharma (5):
  RDMA/ocrdma: Avoid posting DPP requests for RDMA READ
  be2net: issue shutdown event to ocrdma driver
  RDMA/ocrdma: Handle shutdown event from be2net driver
  RDMA/ocrdma: Remove hardcoding of the max DPP QPs supported
  RDMA/ocrdma: Delete AH table if ocrdma_init_hw fails after AH table
    creation

Mitesh Ahuja (3):
  RDMA/ocrdma: Allow only SEND opcode in case of UD QPs
  RDMA/ocrdma: Do proper cleanup evenif FW is in error state
  RDMA/ocrdma: Return proper value for max_mr_size

Selvin Xavier (7):
  RDMA/ocrdma: Query and initalize the PFC SL
  RDMA/ocrdma: Adding hca_type and fixing fw_version string in device
    atrributes
  RDMA/ocrdma: Avoid reporting wrong completions in case of error CQEs
  RDMA/ocrdma : Add missing adapter mailbox opcodes
  RDMA/ocrdma: Increase the size of STAG array in dev structure to 16K
  RDMA/ocrdma: Initialize the GID table while registering the device
  RDMA/ocrdma: Fixing a sparse warning

 drivers/infiniband/hw/ocrdma/ocrdma.h       |   24 +++-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c    |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  197 ++++++++++++++++++++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.h    |    2 +
 drivers/infiniband/hw/ocrdma/ocrdma_main.c  |   83 +++++++++++-
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |  148 ++++++++++++++++-----
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |   34 ++++-
 drivers/net/ethernet/emulex/benet/be.h      |    1 +
 drivers/net/ethernet/emulex/benet/be_main.c |    1 +
 drivers/net/ethernet/emulex/benet/be_roce.c |   18 ++-
 drivers/net/ethernet/emulex/benet/be_roce.h |    3 +-
 11 files changed, 465 insertions(+), 48 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
