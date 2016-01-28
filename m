From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-4.5-rc2 V1 0/5] Mellanox drivers fixes
Date: Thu, 28 Jan 2016 17:51:45 +0200
Message-ID: <1453996310-3360-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series is a set of fixes, which mainly targets the mlx5 driver.

Patch 0001 fixes missing bits in uverbs_ex_cmd. These bits were
omitted as we assumed [1] would be merged to the RDMA tree.
Since that's not the case, we have to add these two bits in order
to support features like completion timestamping and cross-channel.

Patch 0002 fixes a compatibility issue between an old libmlx5 and a
new kernel. Patch 0003 fixes a possibly use of NULL pointer.
Patch 0004 fixes a wrong size reading of a hardware ABI field.
These bugs were introduced by the Raw Ethernet series.

Patch 0005 fixes a bug, where an IPv6 header for GSI QP used the
wrong length. This code is used by the mlx4 driver RoCE v2 code
path.

These patches are applied on Linux v4.5-rc1.

Regards,
Matan

[1] http://www.spinics.net/lists/linux-rdma/msg30019.html

Changes from V0:
  1. Fixed for-4.5-rc1 to for-4.5-rc2.
  2. Rephrased some commit messages.

Majd Dibbiny (2):
  IB/mlx5: Fix reqlen validation in mlx5_ib_alloc_ucontext
  IB/mlx5: Fix use of null pointer PD

Maor Gottlieb (1):
  IB/mlx5: Use MLX5_GET to get end_padding_mode

Matan Barak (1):
  IB/mlx5: Add CREATE_CQ and CREATE_QP to uverbs_ex_cmd_mask

Moni Shoua (1):
  IB/core: Set correct payload length for RoCEv2 over IPv6

 drivers/infiniband/core/ud_header.c |  7 ++++---
 drivers/infiniband/hw/mlx5/main.c   |  8 ++++++--
 drivers/infiniband/hw/mlx5/qp.c     | 20 ++++++++++----------
 3 files changed, 20 insertions(+), 15 deletions(-)

-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
