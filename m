From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/4] batch of maintainance patches for 3.7
Date: Thu, 23 Aug 2012 17:09:01 +0300
Message-ID: <1345730945-1843-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, 

Here's a batch with few simple patches, please apply for 3.7

Or.

Dotan Barak (3):
  IB/core: Remove unused variables in ucm/ucma
  IB/mlx4: Fill in sq_sig_type in query QP
  net/mlx4_core: Fix wrong offset in query device caps

Or Gerlitz (1):
  net/mlx4_core: Remove annoying debug message in the resource tracker

 drivers/infiniband/core/ucm.c                      |    1 -
 drivers/infiniband/core/ucma.c                     |    1 -
 drivers/infiniband/hw/mlx4/qp.c                    |    4 ++++
 drivers/net/ethernet/mellanox/mlx4/fw.c            |    2 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    2 --
 5 files changed, 5 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
