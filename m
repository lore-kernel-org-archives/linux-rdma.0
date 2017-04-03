From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 04/10] IB/mlx5: Fix implicit MR GC
Date: Mon,  3 Apr 2017 13:06:34 +0300
Message-ID: <20170403100640.3332-5-leon@kernel.org>
References: <20170403100640.3332-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403100640.3332-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When implicit MR's leaf MKey becomes unused, i.e. when it's
last page being released my MMU invalidation it is marked as "dying"
and scheduled for release by garbage collector.
Currentle consequent page fault may remove "dying" flag.
Treat leaf MKey as non-existent once it was scheduled to removal
by GC.

Fixes: 81713d3788d2 ('IB/mlx5: Add implicit MR support')
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 3bfa3a9c3be0..b506321f5cb7 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -57,7 +57,7 @@ static int check_parent(struct ib_umem_odp *odp,
 {
 	struct mlx5_ib_mr *mr = odp->private;
 
-	return mr && mr->parent == parent;
+	return mr && mr->parent == parent && !odp->dying;
 }
 
 static struct ib_umem_odp *odp_next(struct ib_umem_odp *odp)
@@ -158,13 +158,6 @@ static void mr_leaf_free_action(struct work_struct *work)
 	mr->parent = NULL;
 	synchronize_srcu(&mr->dev->mr_srcu);
 
-	if (!READ_ONCE(odp->dying)) {
-		mr->parent = imr;
-		if (atomic_dec_and_test(&imr->num_leaf_free))
-			wake_up(&imr->q_leaf_free);
-		return;
-	}
-
 	ib_umem_release(odp->umem);
 	if (imr->live)
 		mlx5_ib_update_xlt(imr, idx, 1, 0,
@@ -436,8 +429,6 @@ static struct ib_umem_odp *implicit_mr_get_data(struct mlx5_ib_mr *mr,
 		nentries++;
 	}
 
-	odp->dying = 0;
-
 	/* Return first odp if region not covered by single one */
 	if (likely(!result))
 		result = odp;
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
