From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH FIXES 1/2] IB/mlx4: Fix spinlock order to avoid lockdep warnings
Date: Tue, 27 Nov 2012 18:24:29 +0200
Message-ID: <1354033470-12724-2-git-send-email-ogerlitz@mellanox.com>
References: <1354033470-12724-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354033470-12724-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

The lockdep checker warned about taking a hard-irq-unsafe lock
(sriov->id_map_lock) inside a hard-irq-safe lock (sriov->going_down_lock).

Since id_map_lock is never taken in the interrupt context, we can
simply reverse the order of taking the two spinlocks, thus avoiding
the warning and the depencency.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index 80079e5..dbc99d4 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -268,15 +268,15 @@ static void schedule_delayed(struct ib_device *ibdev, struct id_map_entry *id)
 	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sriov->going_down_lock, flags);
 	spin_lock(&sriov->id_map_lock);
+	spin_lock_irqsave(&sriov->going_down_lock, flags);
 	/*make sure that there is no schedule inside the scheduled work.*/
 	if (!sriov->is_going_down) {
 		id->scheduled_delete = 1;
 		schedule_delayed_work(&id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
 	}
-	spin_unlock(&sriov->id_map_lock);
 	spin_unlock_irqrestore(&sriov->going_down_lock, flags);
+	spin_unlock(&sriov->id_map_lock);
 }
 
 int mlx4_ib_multiplex_cm_handler(struct ib_device *ibdev, int port, int slave_id,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
