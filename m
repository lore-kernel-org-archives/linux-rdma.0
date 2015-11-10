From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 0/3] Introduce device attribute rdma_read_access_flags
Date: Tue, 10 Nov 2015 12:44:12 +0200
Message-ID: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of each ULP being aware of iWARP/IB protocol in order
to determine the rdma_read access flags, have it accessible
as an attribute in the ib_device.

Patch 2,3 fixes RDS and svcrdma which gave remote access to rdma_reads
unconditionally.

This patchset goes on top of Christoph's device attributes merge into
struct ib_device.

Sagi Grimberg (3):
  IB/core: Expose a device attribute for rdma_read access flags
  svcrdma: Use device rdma_read_access_flags
  RDS_IW: Use device rdma_read_access_flags

 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  2 ++
 drivers/infiniband/hw/cxgb4/provider.c       |  2 ++
 drivers/infiniband/hw/mlx4/main.c            |  1 +
 drivers/infiniband/hw/mlx5/main.c            |  1 +
 drivers/infiniband/hw/mthca/mthca_provider.c |  1 +
 drivers/infiniband/hw/nes/nes_verbs.c        |  2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  1 +
 drivers/infiniband/hw/qib/qib_verbs.c        |  1 +
 drivers/staging/rdma/hfi1/verbs.c            |  2 ++
 include/rdma/ib_verbs.h                      |  1 +
 net/rds/iw_send.c                            | 17 ++++++++++-------
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c      |  2 +-
 12 files changed, 25 insertions(+), 8 deletions(-)

-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
