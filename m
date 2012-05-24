From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.5 0/3] mlx4 fixes
Date: Thu, 24 May 2012 16:08:06 +0300
Message-ID: <1337864889-20886-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland, 

So here's a batch with three fixes to the mlx4 driver, I still don't
have the patch that deals with fixing the MTT scaling by RAM size ready,
hope to get there next week.

Jack Morgenstein (1):
  net/mlx4_core: Fix setting VL_cap in mlx4_SET_PORT wrapper flow

Sagi Grimberg (1):
  IB/mlx4: Fix max_wqe capacity report for query device

Shlomo Pongratz (1):
  IB/mlx4: Fix EQ deallocation under legacy mode

 drivers/infiniband/hw/mlx4/main.c         |   21 ++++++++-------------
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |    8 ++++++++
 drivers/infiniband/hw/mlx4/qp.c           |   25 +++++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx4/port.c |    4 ++--
 4 files changed, 37 insertions(+), 21 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
