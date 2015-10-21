From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH] IB/mlx5: Postpone remove_keys under knowledge of coming preemption
Date: Wed, 21 Oct 2015 09:21:17 +0300
Message-ID: <1445408477-24886-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The remove_keys() logic is performed as garbage collection task. Such
task is intended to be run when no other active processes are running.

The need_resched() will return TRUE if there are user tasks to be
activated in near future.

In such case, we don't execute remove_keys() and postpone
the garbage collection work to try to run in next cycle,
in order to free CPU resources to other tasks.

The possible pseudo-code to trigger such scenario:
1. Allocate a lot of MR to fill the cache above the limit.
2. Wait a small amount of time "to calm" the system.
3. Start CPU extensive operations on multi-node cluster.
4. Expect performance degradation during MR cache shrink operation.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 54a15b5..45ce00e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -381,7 +381,19 @@
 			}
 		}
 	} else if (ent->cur > 2 * ent->limit) {
-		if (!someone_adding(cache) &&
+		/*
+		 * The remove_keys() logic is performed as garbage collection
+		 * task. Such task is intended to be run when no other active
+		 * processes are running.
+		 *
+		 * The need_resched() will return TRUE if there are user tasks
+		 * to be activated in near future.
+		 *
+		 * In such case, we don't execute remove_keys() and postpone
+		 * the garbage collection work to try to run in next cycle,
+		 * in order to free CPU resources to other tasks.
+		 */
+		if (!need_resched() && !someone_adding(cache) &&
 		    time_after(jiffies, cache->last_add + 300 * HZ)) {
 			remove_keys(dev, i, 1);
 			if (ent->cur > ent->limit)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
