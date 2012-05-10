From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/6] IB: 2nd batch of fixes for 3.5
Date: Thu, 10 May 2012 23:28:03 +0300
Message-ID: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This is a 2nd batch of fixes for 3.5, mostly to the mlx4 (core and ib) driver:

[PATCH for-next V1 1/6] net/mlx4_core: Change bitmap allocator to work in round-robin fashion
[PATCH for-next 2/6] IB/core: fix mismatch between locked and pinned pages
[PATCH for-next 3/6] IB/mlx4: Fix parameter checking in create_cq
[PATCH for-next 4/6] IB/core: Fix IB_SA_COMP_MASK macro
[PATCH for-next 5/6] net/mlx4: Adjust initial value of vl_cap in mlx4_SET_PORT
[PATCH for-next 6/6] IB/mlx4: bug fix for mlx4_ib_add error flow

The first patch is V1 to the change in the bitmap allocator, where your feedback was applied. 

The second patch is fix from Yishai Hadas to wrong setting done in umem.c, the bug
was introduced in 3.2, so its not regression from 3.4-rc1, sounds like it fits -stable

Next is a fix from Eli to create_cq and following that three fixes 
which came up during Jack's work to prepare the SRIOV patches.

BTW - this series should get along fine before the TSS/RSS one, and vise versa

Or.

Eli Cohen (1):
  IB/mlx4: Fix parameter checking in create_cq

Jack Morgenstein (3):
  net/mlx4_core: Change bitmap allocator to work in round-robin fashion
  IB/core: Fix IB_SA_COMP_MASK macro
  IB/mlx4: bug fix for mlx4_ib_add error flow

Or Gerlitz (1):
  net/mlx4: Adjust initial value of vl_cap in mlx4_SET_PORT

Yishai Hadas (1):
  IB/core: fix mismatch between locked and pinned pages

 drivers/infiniband/core/umem.c             |    2 +-
 drivers/infiniband/hw/mlx4/cq.c            |    2 +-
 drivers/infiniband/hw/mlx4/main.c          |    6 +++---
 drivers/net/ethernet/mellanox/mlx4/alloc.c |    3 ---
 drivers/net/ethernet/mellanox/mlx4/port.c  |   12 +++++++++++-
 include/rdma/ib_mad.h                      |    2 +-
 6 files changed, 17 insertions(+), 10 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
