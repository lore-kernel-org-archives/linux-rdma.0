From: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] IB/mlx5: fix debugfs cleanup
Date: Mon, 18 Sep 2017 12:28:48 +0100
Message-ID: <1505734128-21708-1-git-send-email-sudip.mukherjee@codethink.co.uk>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

If delay_drop_debugfs_init() fails in any of the operations to create
debugfs, it is calling delay_drop_debugfs_cleanup() as part of its
cleanup. But delay_drop_debugfs_cleanup() checks for 'dbg' and since
we have not yet pointed 'dbg' to the debugfs we need to cleanup, the
cleanup fails and we are left with stray debugfs elements and also a
memory leak.

Fixes: 4a5fd5d2965c ("IB/mlx5: Add necessary delay drop assignment")
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index ab3c562..05fb4bd 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3837,11 +3837,13 @@ static int delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
 	if (!dbg)
 		return -ENOMEM;
 
+	dev->delay_drop.dbg = dbg;
+
 	dbg->dir_debugfs =
 		debugfs_create_dir("delay_drop",
 				   dev->mdev->priv.dbg_root);
 	if (!dbg->dir_debugfs)
-		return -ENOMEM;
+		goto out_debugfs;
 
 	dbg->events_cnt_debugfs =
 		debugfs_create_atomic_t("num_timeout_events", 0400,
@@ -3865,8 +3867,6 @@ static int delay_drop_debugfs_init(struct mlx5_ib_dev *dev)
 	if (!dbg->timeout_debugfs)
 		goto out_debugfs;
 
-	dev->delay_drop.dbg = dbg;
-
 	return 0;
 
 out_debugfs:
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
