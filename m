From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 0/5] Extended atomics enhancements
Date: Mon,  3 Nov 2014 10:02:41 +0200
Message-ID: <1415001766-8366-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

the first patch in this series cleans some sparse warnings. The rest of the
patches introudce extensions to verbs to add support for extended atomic
operations over Connect-IB

As your IB tree isn't yet rebased to 3.18-rc1, this series was generated
against net-next to account for mlx5 changes which went in rc1 and are
assumed by some of the patches.

Eli

Eli Cohen (5):
  IB/mlx5: Fix sparse warnings
  IB/core: Add support for extended query device caps
  IB/core: Extend atomic operations
  IB/mlx5: Add extended atomic support
  IB/mlx4: Modify mlx4 to comply with extended atomic definitions

 drivers/infiniband/core/uverbs.h               |   1 +
 drivers/infiniband/core/uverbs_cmd.c           | 141 ++++++++++++++++++-------
 drivers/infiniband/core/uverbs_main.c          |   3 +-
 drivers/infiniband/hw/mlx4/main.c              |   3 +
 drivers/infiniband/hw/mlx5/main.c              |  47 ++++++++-
 drivers/infiniband/hw/mlx5/qp.c                |  42 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   |  51 ++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c |  21 ++--
 include/linux/mlx5/device.h                    |   4 +-
 include/linux/mlx5/driver.h                    |  55 ++++++++--
 include/linux/mlx5/mlx5_ifc.h                  |  20 ++++
 include/rdma/ib_verbs.h                        |   7 +-
 include/uapi/rdma/ib_user_verbs.h              |  26 ++++-
 13 files changed, 346 insertions(+), 75 deletions(-)

-- 
2.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
