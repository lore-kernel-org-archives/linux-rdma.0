From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/2] mlx5 misc
Date: Sun, 29 Oct 2017 15:01:08 +0200
Message-ID: <1509282070-1391-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set handles few mlx5 driver issues, details below.

The first patch from Majd consider the mmap command to issue to mlx5 kernel
driver based on the question whether Blueflame is used.

The second patch from Ariel fixes wrong size calculation of the bit map table
when the hugepage allocation mode is used.

PR was sent:
https://github.com/linux-rdma/rdma-core/pull/235 

Yishai

Ariel Levkovich (1):
  mlx5: Fix wrong bitmap table allocation size calculation

Majd Dibbiny (1):
  mlx5: Use non-cached mapping when Blueflame is not used

 providers/mlx5/buf.c    |  2 +-
 providers/mlx5/cq.c     |  2 +-
 providers/mlx5/mlx5.c   | 72 +++++++++++++++++++++++++++++++++++++------------
 providers/mlx5/mlx5.h   | 13 +++++++--
 providers/mlx5/mlx5dv.h |  5 ++++
 5 files changed, 73 insertions(+), 21 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
