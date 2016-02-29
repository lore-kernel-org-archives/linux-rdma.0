From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/3] Add memory window user-space support to mlx5
Date: Mon, 29 Feb 2016 18:05:27 +0200
Message-ID: <1456761930-11222-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series adds memory window user-space support to the mlx5 driver.
Memory windows in mlx5 based hardware consists of a Mkey pointing to
another set of MKeys by using KLMs as pointers.

The required kernel part for user-space memory windows consists of
allocating and deallocating these MKeys and exposing the supported
functionality via query_device.
Currently, we support Mkeys that either check the QP or doesn't
check it. This correspond to memory window of type 2B and 1
(respectively).

The user-space driver could pass the required number of KLMs in order
to create more sophisticated Mkeys.

Patch 0001 refactores the mlx5_core_mr to mlx5_core_mkey, as mr
doesn't represent accurately enough the usage of mkey to memory
windows.
Patch 0002 adds vendor specific data to ib_uverbs_alloc_mw.
Patch 0003 adds the actual memory window support to the mlx5 driver.

This series depends on
"net/mlx5: Use offset based reserved field names in the IFC header file"
posted and accepted to net.

This series conflicts (trivially) with memory re-registeration for mlx5
posted on linux-rdma.

Thanks,
Matan

Matan Barak (3):
  net/mlx5: Refactor mlx5_core_mr to mkey
  IB/core: Add vendor's specific data to alloc mw
  IB/mlx5: Add memory windows allocation support

 drivers/infiniband/core/uverbs_cmd.c              |   8 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c       |   3 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h            |   3 +-
 drivers/infiniband/hw/cxgb4/mem.c                 |   4 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h              |   3 +-
 drivers/infiniband/hw/mlx4/mr.c                   |   4 +-
 drivers/infiniband/hw/mlx5/cq.c                   |  16 +--
 drivers/infiniband/hw/mlx5/main.c                 |  13 +++
 drivers/infiniband/hw/mlx5/mlx5_ib.h              |  20 +++-
 drivers/infiniband/hw/mlx5/mr.c                   | 133 ++++++++++++++++++----
 drivers/infiniband/hw/mlx5/odp.c                  |  10 +-
 drivers/infiniband/hw/mlx5/user.h                 |   7 ++
 drivers/infiniband/hw/nes/nes_verbs.c             |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c      |  54 ++++-----
 include/linux/mlx5/driver.h                       |  24 ++--
 include/linux/mlx5/mlx5_ifc.h                     |   4 +-
 include/linux/mlx5/qp.h                           |   4 +-
 include/rdma/ib_verbs.h                           |   3 +-
 21 files changed, 237 insertions(+), 99 deletions(-)

-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
