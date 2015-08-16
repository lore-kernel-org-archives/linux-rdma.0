From: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/7] Add support for multicast loopback prevention to mlx4
Date: Sun, 16 Aug 2015 19:05:26 +0300
Message-ID: <1439741133-30145-1-git-send-email-eranbe@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This patch-set adds a new  implementation for multicast loopback prevention for
mlx4 driver.  The current implementation is very limited, especially if link
layer is Ethernet. The new implementation is based on HW feature of dropping
incoming multicast packets if the sender QP counter index is equal to the
receiver counter index.

Patch 0001 extends ib_uverbs_create_qp in order to allow receiving the
multicast loopback flag at create flags.
Patch 0002 adds an infrastructure for the counters' loopback prevention in the
mlx4_core.
Patch 0003 modifies mlx4_en QPs to use the new loopback prevention mode.
Patches 0004-0006 implements this feature for mlx4_ib driver.
Patch 0007 allows setting IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK in create_flag
field both from uverbs and ib_create_qp.

Thanks,
Eran.

Eran Ben Elisha (5):
  IB/core: Extend ib_uverbs_create_qp
  IB/core: Allow setting create flags in QP init attribute
  IB/mlx4: Add IB counters table
  IB/mlx4: Add counter based implementation for QP multicast loopback
    block
  IB/mlx4: Add support for blocking multicast loopback QP creation user
    flag

Maor Gottlieb (2):
  net/mlx4_core: Add support for filtering multicast loopback
  net/mlx4_en: Implement mcast loopback prevention for ETH qps

 drivers/infiniband/core/uverbs.h                   |   1 +
 drivers/infiniband/core/uverbs_cmd.c               | 256 +++++++++++++++------
 drivers/infiniband/core/uverbs_main.c              |   1 +
 drivers/infiniband/hw/mlx4/mad.c                   |  25 +-
 drivers/infiniband/hw/mlx4/main.c                  |  66 ++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  10 +-
 drivers/infiniband/hw/mlx4/qp.c                    |  88 ++++++-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |  22 ++
 drivers/net/ethernet/mellanox/mlx4/en_resources.c  |  25 ++
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   6 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   3 +-
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  19 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |  30 ++-
 include/linux/mlx4/device.h                        |   2 +
 include/linux/mlx4/qp.h                            |  24 +-
 include/uapi/rdma/ib_user_verbs.h                  |  26 +++
 16 files changed, 496 insertions(+), 108 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
