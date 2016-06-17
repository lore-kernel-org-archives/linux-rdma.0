From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] ConnectX-4/Connect-IB Port Counters
Date: Fri, 17 Jun 2016 15:10:54 +0300
Message-ID: <1466165456-31857-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is supplementary part of mlx5 driver to generic IB counters infrastructure.

Mark Bloch (2):
  IB/mlx5: Add per port counters
  IB/mlx5: Add port protocol stats

 drivers/infiniband/hw/mlx5/main.c    | 134 ++++++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |   6 ++
 drivers/infiniband/hw/mlx5/qp.c      |   9 +++
 3 files changed, 147 insertions(+), 2 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
