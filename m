From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] batch of mlx4 patches for 3.4
Date: Tue,  6 Mar 2012 15:50:48 +0200
Message-ID: <1331041851-20498-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Here's a small batch of patches for 3.4 to the mlx4 driver, its made of
a fix from Eli, report on  thermal error event from Jack and a cleanup
from me.

Or.


Eli Cohen (1):
  IB/mlx4: Fix mlx4_ib_poll_cq possible missed completion

Jack Morgenstein (1):
  net/mlx4: report thermal error event

Or Gerlitz (1):
  net/mlx4: remove redundant maintainance of extended port capabilities

 drivers/infiniband/hw/mlx4/cq.c           |    3 +-
 drivers/infiniband/hw/mlx4/main.c         |   27 ++++++++----------
 drivers/net/ethernet/mellanox/mlx4/eq.c   |   32 +++++++++++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/main.c |    7 -----
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    5 +++-
 drivers/net/ethernet/mellanox/mlx4/port.c |   43 -----------------------------
 include/linux/mlx4/device.h               |   10 +++---
 7 files changed, 53 insertions(+), 74 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
