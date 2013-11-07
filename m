From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/6] Add flow steering support for IPoIB
Date: Thu,  7 Nov 2013 15:25:11 +0200
Message-ID: <1383830717-17312-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This series adds on the flow-steering patches that were merged in 3.12

Now flow steering rules can be set such that they steer UD 
traffic targeted to IPoIB netdevice into applications IB UD QP.

For that end, IPoIB provides hint to the low-level device through
a QP creation flag that this QP may be subject to flow-steering.

FWWI, this patch set has nothing to do with the uverbs extensions series.

Matan and Or.

Matan Barak (6):
  IB/core: Add flow-steering support for IPoIB UD traffic
  IB/core: Add support for IB L2 device managed steering
  net/mlx4_core: Add support for steer-able IB UD QPs
  IB/mlx4_ib: Enable device managed steering support for IB ports too
  IB/mlx4_ib: Add mechanism to support flow-steering over IB links
  IB/mlx4_ib: Add support for steer-able IB UD QPs

 drivers/infiniband/hw/mlx4/main.c                  |  272 +++++++++++++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   12 +
 drivers/infiniband/hw/mlx4/qp.c                    |   53 ++++-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    3 +
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |    9 +
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   10 +
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |   17 ++
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    5 +
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |   10 +
 include/linux/mlx4/cmd.h                           |    1 +
 include/linux/mlx4/device.h                        |    6 +-
 include/rdma/ib_verbs.h                            |   17 ++-
 12 files changed, 393 insertions(+), 22 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
