From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 0/5] Dynamically Connected support
Date: Thu,  6 Nov 2014 17:52:34 +0200
Message-ID: <1415289159-4376-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, richardg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

the following series of patches introduces a new transport service named DC.
Support is added at IB/core layer, uverbs interface to userspace and mlx5 for
Connect-IB devices. Details on the new transport can be found in the first
patch in the series.

Eli

Eli Cohen (5):
  IB/core: Add DC transport support
  IB/uverbs: Add userspace interface to DC verbs
  mlx5_core: Add DC support at mlx5 core layer
  mlx5_ib: Add support for DC
  mlx5_core: Update mlx5_command_str with DC commands

 drivers/infiniband/core/uverbs.h                  |  11 +
 drivers/infiniband/core/uverbs_cmd.c              | 474 +++++++++++++++++++---
 drivers/infiniband/core/uverbs_main.c             |  35 +-
 drivers/infiniband/core/verbs.c                   |  87 ++++
 drivers/infiniband/hw/mlx5/main.c                 |  19 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |  24 ++
 drivers/infiniband/hw/mlx5/qp.c                   | 289 ++++++++++++-
 drivers/infiniband/hw/mlx5/user.h                 |  41 ++
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c     |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 110 +++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c      |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/qp.c      | 185 +++++++++
 include/linux/mlx5/device.h                       |  12 +
 include/linux/mlx5/driver.h                       |  24 +-
 include/linux/mlx5/mlx5_ifc.h                     | 179 ++++++++
 include/linux/mlx5/qp.h                           |  39 +-
 include/rdma/ib_verbs.h                           |  88 +++-
 include/uapi/rdma/ib_user_verbs.h                 | 126 +++++-
 19 files changed, 1710 insertions(+), 75 deletions(-)

-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
