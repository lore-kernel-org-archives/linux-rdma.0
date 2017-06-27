From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/2] Export FW version for RDMAtool
Date: Tue, 27 Jun 2017 17:06:48 +0300
Message-ID: <20170627140650.23510-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

hi Doug,

This patch set is based on previously sent RDMA netlink work.

Thanks

Leon Romanovsky (2):
  RDMA: Simplify get firmware interface
  RDMA/netlink: Export FW version

 drivers/infiniband/core/device.c               | 4 ++--
 drivers/infiniband/core/nldev.c                | 8 ++++++++
 drivers/infiniband/core/sysfs.c                | 4 ++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c    | 5 ++---
 drivers/infiniband/hw/cxgb4/provider.c         | 5 ++---
 drivers/infiniband/hw/hfi1/verbs.c             | 5 ++---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c      | 5 ++---
 drivers/infiniband/hw/mlx4/main.c              | 5 ++---
 drivers/infiniband/hw/mlx5/main.c              | 5 ++---
 drivers/infiniband/hw/mthca/mthca_provider.c   | 5 ++---
 drivers/infiniband/hw/nes/nes_verbs.c          | 5 ++---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c     | 5 ++---
 drivers/infiniband/hw/qedr/main.c              | 5 ++---
 drivers/infiniband/hw/usnic/usnic_ib_main.c    | 6 ++----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 5 ++---
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c   | 3 +--
 include/rdma/ib_verbs.h                        | 6 ++++--
 include/uapi/rdma/rdma_netlink.h               | 4 ++++
 18 files changed, 45 insertions(+), 45 deletions(-)

--
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
