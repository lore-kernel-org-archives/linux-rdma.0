From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] MLX5 IB/RoCE traffic counters
Date: Thu, 18 Feb 2016 18:14:58 +0200
Message-ID: <1455812101-1258-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hi Doug,

This patch set modifies the mlx5_ib_process_mad to:
1. Declare support of extended counters.
2. Use PPCNT and query_vport command instead of MAD_IFC, as
   MAD_IFC is deprecated on new firmware versions and doesn't
   support RoCE.

The first two patches add helper functions to read the virtual port
counters and the IB error counters.

The third patch modifies the mlx5_ib_process_mad to use the previously
exposed command to read the counters. In addition, this commit
declares the support of extended counters.

This patch set depends on
"net/mlx5: Use offset based reserved field names in the IFC header file"
which was posted and accepted in net tree.

Majd and Matan

Meny Yossefi (3):
  net/mlx5_core: Add helper function to read virtual port counters
  net/mlx5_core: Add helper function to read IB error counters
  IB/mlx5: Modify MAD reading counters method to use counter registers

 drivers/infiniband/hw/mlx5/mad.c                | 166 ++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/port.c  |  23 ++++
 drivers/net/ethernet/mellanox/mlx5/core/vport.c |  40 ++++++
 include/linux/mlx5/device.h                     |  26 +++-
 include/linux/mlx5/driver.h                     |   2 +
 include/linux/mlx5/mlx5_ifc.h                   |  35 ++++-
 include/linux/mlx5/vport.h                      |   2 +
 7 files changed, 281 insertions(+), 13 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
