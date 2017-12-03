From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 0/3] Add tunnel support
Date: Sun,  3 Dec 2017 18:03:34 +0200
Message-ID: <1512317017-6223-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sending V1 to handle few notes from GITHUB, details below.

This series from Maor is the supplementary part of the kernel series that was
merged into 4.15.

It introduces the following support for tunneling packets:
1) RSS on the tunneled packet.
2) Tunneling offloads support for mlx5 devices via the DV API.

PR:
https://github.com/linux-rdma/rdma-core/pull/265

Changes from V0:
- Moved to use (1UL << 31) for IBV_RX_HASH_INNER as part of the enum.
- Improved the man page to better describe the inner/outer terms.
- Sorted the names of the exported symbols from mlx5 that were introduced
  as part of this V16 release.

Yishai

Maor Gottlieb (3):
  verbs: Add support in RSS of the inner packet
  mlx5: Add tunnel offloads support in direct verbs
  mlx5: Report tunneling offloads capabilities

 debian/ibverbs-providers.symbols         |  1 +
 libibverbs/man/ibv_create_qp_ex.3        | 20 ++++++++++++
 libibverbs/verbs.h                       |  3 +-
 providers/mlx5/libmlx5.map               |  1 +
 providers/mlx5/man/mlx5dv_query_device.3 | 15 ++++++++-
 providers/mlx5/mlx5-abi.h                |  5 ++-
 providers/mlx5/mlx5.c                    |  5 +++
 providers/mlx5/mlx5.h                    |  1 +
 providers/mlx5/mlx5dv.h                  | 27 +++++++++++++++-
 providers/mlx5/verbs.c                   | 53 ++++++++++++++++++++++++++++----
 10 files changed, 121 insertions(+), 10 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
