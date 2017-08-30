From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/2] mlx5 DV fixes
Date: Wed, 30 Aug 2017 17:19:22 +0300
Message-ID: <1504102764-21638-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series fixes 2 issues in the mlx5 DV flow:
Patch #1: Rename arm_db that was lastly added to match content.
Patch #2: Fix compile warning.

pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/202

Leon Romanovsky (2):
  mlx5: Rename arm_db pointer to be cq_uar to better describe the
    content
  mlx5: Convert explicitly to signed char

 providers/mlx5/man/mlx5dv_init_obj.3 | 2 +-
 providers/mlx5/mlx5.c                | 4 ++--
 providers/mlx5/mlx5dv.h              | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
