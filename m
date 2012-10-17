From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-3.7 2/3] IB/mlx4: Synchronize cleanup of MCGs in mcg paravirtualization
Date: Wed, 17 Oct 2012 18:42:59 +0200
Message-ID: <1350492181-13471-3-git-send-email-ogerlitz@mellanox.com>
References: <1350492181-13471-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350492181-13471-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

A client re-register event invokes cleanup of all MCGs.
This is required to protect against misbehaved guests leading to
corruption of join/leave database. However, since cleaning up the MCGs
is a heavy operation, it is pushed to a work queue for further processing.
Client re-register is also propagated to ULPs (e.g IPoIB).

However, since the cleanup is performed in a workqueue, the ULP could
leave and re-join groups before the cleanup occurs.
In this case, when the cleanup takes place, it prunes the (newly-joined) MCGs
and the ULP is left without actual MCGs while believing it joined them.

Fix this by setting the flushing flag before invoking the cleanup task
and clearing it after flushing is complete.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mcg.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 44ff480..25b2cdf 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -1075,10 +1075,6 @@ static void _mlx4_ib_mcg_port_cleanup(struct mlx4_ib_demux_ctx *ctx, int destroy
 	unsigned long end;
 	int count;
 
-	if (ctx->flushing)
-		return;
-
-	ctx->flushing = 1;
 	for (i = 0; i < MAX_VFS; ++i)
 		clean_vf_mcast(ctx, i);
 
@@ -1108,9 +1104,6 @@ static void _mlx4_ib_mcg_port_cleanup(struct mlx4_ib_demux_ctx *ctx, int destroy
 		force_clean_group(group);
 	}
 	mutex_unlock(&ctx->mcg_table_lock);
-
-	if (!destroy_wq)
-		ctx->flushing = 0;
 }
 
 struct clean_work {
@@ -1124,6 +1117,7 @@ static void mcg_clean_task(struct work_struct *work)
 	struct clean_work *cw = container_of(work, struct clean_work, work);
 
 	_mlx4_ib_mcg_port_cleanup(cw->ctx, cw->destroy_wq);
+	cw->ctx->flushing = 0;
 	kfree(cw);
 }
 
@@ -1131,13 +1125,20 @@ void mlx4_ib_mcg_port_cleanup(struct mlx4_ib_demux_ctx *ctx, int destroy_wq)
 {
 	struct clean_work *work;
 
+	if (ctx->flushing)
+		return;
+
+	ctx->flushing = 1;
+
 	if (destroy_wq) {
 		_mlx4_ib_mcg_port_cleanup(ctx, destroy_wq);
+		ctx->flushing = 0;
 		return;
 	}
 
 	work = kmalloc(sizeof *work, GFP_KERNEL);
 	if (!work) {
+		ctx->flushing = 0;
 		mcg_warn("failed allocating work for cleanup\n");
 		return;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
