From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH for-next 0/3] Mellanox ConnectX-3 Diagnostic Counters
Date: Tue, 19 Jul 2016 20:54:55 +0300
Message-ID: <1468950898-9674-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch series adds diagnostic hardware counters for Mellanox
ConnectX-3 which uses the dynamic IB counters infrastructure.

This series includes three patches, the first two add the necessary
functions to read the counters from the firmware and check for
firmware capability. The third patch exposes the functions needed
for the counter infrastructure.

The counters exposed are applicable for IB and RoCE.

Mark Bloch (3):
  net/mlx4: Add diagnostic counters capability bit
  net/mlx4: Query performance and diagnostics counters
  IB/mlx4: Add diagnostic hardware counters

 drivers/infiniband/hw/mlx4/main.c       | 198 +++++++++++++++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |   9 ++
 drivers/net/ethernet/mellanox/mlx4/fw.c |  40 +++++++
 include/linux/mlx4/device.h             |   7 ++
 4 files changed, 253 insertions(+), 1 deletion(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
