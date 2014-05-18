From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] mlx5 signature handover fixes for kernel 3.16
Date: Sun, 18 May 2014 18:32:37 +0300
Message-ID: <1400427160-11314-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset addresses 3 issues signature handover mlx5 implementation.
Patch #1 addresses a bug in signature mkey length when describing an
interleaved buffer (data and protection).
Patch #2 is a micro-optimization for interleaved buffers.
Patch #3 addresses a possible issue for future T10-PI implementations.

Sagi Grimberg (3):
  mlx5: Fix signature handover operation for interleaved buffers
  mlx5: Simplify signature handover wqe for interleaved buffers
  mlx5: Copy DIF fields only when input and output space values match

 drivers/infiniband/hw/mlx5/qp.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
