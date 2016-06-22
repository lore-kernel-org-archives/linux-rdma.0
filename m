From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma 00/11] IB core,mlx5,mlx4 fixes for 4.7-rc4
Date: Wed, 22 Jun 2016 17:27:21 +0300
Message-ID: <1466605652-24798-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

We are sending 11 patches with fixes for 4.7-rc4.

Since most of the patches are one liners which will apply
cleanly on current rc4 and no merge conflicts is expected for
future ->next branches, we decided to send them as one patch series.

These patches are available in the "topic/fixes-ib" branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/fixes-ib

Thanks

Alex Vesker (1):
  IB/core: Fix RoCE v1 multicast join logic issue

Chuck Lever (1):
  IB/mlx4: Prevent cross page boundary allocation

Dotan Barak (1):
  IB/mlx4: Fix memory leak if QP creation failed

Eli Cohen (2):
  IB/core: Fix false search of the IB_SA_WELL_KNOWN_GUID
  IB/mlx5: Fix post send fence logic

Maor Gottlieb (1):
  IB/uverbs: Initialize ib_qp_init_attr with zeros

Talat Batheesh (2):
  IB/core: Fix no default GIDs when netdevice reregisters
  IB/mlx5: Fix wrong naming of port_rcv_data counter

Yishai Hadas (3):
  IB/mlx4: Fix the SQ size of an RC QP
  IB/mlx4: Fix error flow when sending mads under SRIOV
  IB/mlx4: Check that port number is valid in flow steering create flow

 drivers/infiniband/core/cache.c      |  4 +++-
 drivers/infiniband/core/cma.c        |  8 ++++----
 drivers/infiniband/core/uverbs_cmd.c |  2 +-
 drivers/infiniband/core/verbs.c      | 16 ++++++++++------
 drivers/infiniband/hw/mlx4/mad.c     | 24 ++++++++++++++++++------
 drivers/infiniband/hw/mlx4/main.c    |  3 +++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  2 +-
 drivers/infiniband/hw/mlx4/mr.c      | 34 +++++++++++++++++-----------------
 drivers/infiniband/hw/mlx4/qp.c      |  6 ++++--
 drivers/infiniband/hw/mlx5/mad.c     |  2 +-
 drivers/infiniband/hw/mlx5/qp.c      |  7 ++++---
 include/linux/mlx5/qp.h              |  1 +
 12 files changed, 67 insertions(+), 42 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
