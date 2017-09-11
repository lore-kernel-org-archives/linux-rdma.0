From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/2] Expose mlx5 multi packet capabilities
Date: Mon, 11 Sep 2017 14:43:03 +0300
Message-ID: <1505130185-32658-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series from Bodong is the supplementary part of the kernel series that was
merged into 4.14.

It gets from the kernel the information whether multi packet WQE is allowed in
SQ and whether enhanced multi packet send WQE is supported. This information is
reported by the mlx5dv_query_device() DV API.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/217

Bodong Wang (2):
  mlx5: Report if kernel allows using MPW in SQ
  mlx5: Report enhanced multi packet send WQE capability

 providers/mlx5/man/mlx5dv_query_device.3 | 4 +++-
 providers/mlx5/mlx5-abi.h                | 6 ++++++
 providers/mlx5/mlx5.c                    | 7 +++++--
 providers/mlx5/mlx5.h                    | 4 +++-
 providers/mlx5/mlx5dv.h                  | 4 +++-
 providers/mlx5/verbs.c                   | 7 +++++--
 6 files changed, 25 insertions(+), 7 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
