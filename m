From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 0/3]  Verbs support for source QPN
Date: Thu,  7 Sep 2017 15:12:04 +0300
Message-ID: <1504786327-820-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set is the supplementary part of the kernel series that was accepted
upstream into 4.14.

It enables user space applications to create a QP with a given source QP
number. The created QP will use the source QPN as its wire QP number.

This functionality is implemented by mlx5 driver as part of this series to
allow user space applications to accelerate traffic which is typically handled
by IPoIB ULP.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/212

Changes from V0:
Patch #3:
- Improve commit log to better describe the general case.
- Rename MLX5_IPOIB_INLINE_MAX_HEADER_SIZE to more general name as it really is.

Yishai Hadas (3):
  verbs: Enable creating QP with a given source QP number
  mlx5: Add support for managing QP with a given source QP number
  mlx5: Add support for sending UD packets with source QPN

 libibverbs/cmd.c                  |  6 +++-
 libibverbs/kern-abi.h             |  2 +-
 libibverbs/man/ibv_create_qp_ex.3 |  1 +
 libibverbs/verbs.h                |  2 ++
 providers/mlx5/mlx5.h             |  8 ++++-
 providers/mlx5/qp.c               | 68 ++++++++++++++++++++++++++++++++++++++-
 providers/mlx5/verbs.c            | 46 +++++++++++++++++++++-----
 providers/mlx5/wqe.h              |  6 ++++
 8 files changed, 127 insertions(+), 12 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
