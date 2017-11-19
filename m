From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/2] mlx5: Add striding RQ support via the DV API
Date: Sun, 19 Nov 2017 21:21:06 +0200
Message-ID: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series from Noa is the supplementary part of the kernel series that was
merged into 4.15.

This series exposes to mlx5 DV users the ability to create an RQ with the
striding functionality.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/257

Yishai
Noa Osherovich (2):
  mlx5: Report Multi-Packet RQ capabilities through mlx5 direct verbs
  mlx5: Allow creation of a Multi-Packet RQ using direct verbs

 debian/ibverbs-providers.symbols         |  2 +
 providers/mlx5/CMakeLists.txt            |  2 +-
 providers/mlx5/libmlx5.map               |  5 +++
 providers/mlx5/man/mlx5dv_query_device.3 | 14 ++++++-
 providers/mlx5/mlx5-abi.h                | 15 ++++++-
 providers/mlx5/mlx5.c                    |  5 +++
 providers/mlx5/mlx5.h                    |  1 +
 providers/mlx5/mlx5dv.h                  | 59 +++++++++++++++++++++++++++-
 providers/mlx5/verbs.c                   | 67 +++++++++++++++++++++++++++++---
 9 files changed, 159 insertions(+), 11 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
