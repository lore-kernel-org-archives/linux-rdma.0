From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/5] mlx5 fixes for 3.16
Date: Thu, 22 May 2014 14:50:07 +0300
Message-ID: <1400759412-13205-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, 

This patchset contains fixes and minor improvements to the mlx5 driver.

The first patch fixes a memory leak in an error flow in the reg_umr
function. The second adds newly created memory regions to the MR radix
tree when they are created through reg_umr. Patches 3-4 fill some
fields that were left out in MRs and QPs. Patch 5 refactors the UMR
context out of the mlx5_ib_mr struct.

Best regards,
Haggai

Haggai Eran (4):
  IB/mlx5: Fix error handling in reg_umr
  IB/mlx5: Add MR to radix tree in reg_mr_callback
  mlx5: Store MR attributes in mlx5_mr_core during creation and after
    UMR
  IB/mlx5: Set QP offsets and parameters for user QPs and not just for
    kernel QPs

Shachar Raindel (1):
  IB/mlx5: Refactor UMR to have its own context struct

 drivers/infiniband/hw/mlx5/mlx5_ib.h         | 13 ++++-
 drivers/infiniband/hw/mlx5/mr.c              | 76 ++++++++++++++++------------
 drivers/infiniband/hw/mlx5/qp.c              |  4 ++
 drivers/net/ethernet/mellanox/mlx5/core/mr.c |  4 ++
 include/linux/mlx5/driver.h                  |  1 -
 5 files changed, 64 insertions(+), 34 deletions(-)

-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
