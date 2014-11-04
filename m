From: Zheng Li <zheng.x.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] net/mlx4_core: Convert rcu locking to rwlock in CQ.
Date: Tue,  4 Nov 2014 17:23:44 +0800
Message-ID: <1415093024-13041-1-git-send-email-zheng.x.li@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, guru.anbalagane-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, zheng.x.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The mlx4_ib_cq_comp dispatching was racy and this is fixed by using
rcu locking. However, that introduced regression in ib port failure
tests, so changing to rwlock.
rcu_XXX api are used to synchronize threads and use preempt_disable/enable
to make sure that no thread cross other thread but is not safe for interrupts
routines. In this case we are in inteerupt context: mlx4_msi_x_interrupt ->
mlx4_eq_int -> mlx4_cq_completion, so can't use rcu_XXX to protect this code.

The stack is below:
crash> bt
PID: 32068  TASK: ffff880ed14405c0  CPU: 20  COMMAND: "kworker/u:1"
 #0 [ffff880ec7c01a00] __schedule at ffffffff81506664
 #1 [ffff880ec7c01b18] schedule at ffffffff81506d45
 #2 [ffff880ec7c01b28] schedule_timeout at ffffffff8150719c
 #3 [ffff880ec7c01bd8] wait_for_common at ffffffff81506bcd
 #4 [ffff880ec7c01c68] wait_for_completion at ffffffff81506cfd
 #5 [ffff880ec7c01c78] synchronize_sched at ffffffff810dda48
 #6 [ffff880ec7c01cc8] mlx4_cq_free at ffffffffa027e67e [mlx4_core]
 #7 [ffff880ec7c01cf8] mlx4_ib_destroy_cq at ffffffffa03238a3 [mlx4_ib]
 #8 [ffff880ec7c01d18] ib_destroy_cq at ffffffffa0301c9e [ib_core]
 #9 [ffff880ec7c01d28] rds_ib_conn_shutdown at ffffffffa041cf5d [rds_rdma]
 #10 [ffff880ec7c01dd8] rds_conn_shutdown at ffffffffa02b7f18 [rds]
 #11 [ffff880ec7c01e38] rds_shutdown_worker at ffffffffa02bd14a [rds]
 #12 [ffff880ec7c01e58] process_one_work at ffffffff8108c3b9
 #13 [ffff880ec7c01ea8] worker_thread at ffffffff8108ccfa
 #14 [ffff880ec7c01ee8] kthread at ffffffff810912d7
 #15 [ffff880ec7c01f48] kernel_thread_helper at ffffffff815123c4

Signed-off-by: Zheng Li <zheng.x.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Guru <guru.anbalagane-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: John Sobecki <john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/cq.c   |   26 +++++++++++++++-----------
 drivers/net/ethernet/mellanox/mlx4/mlx4.h |    2 +-
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 56022d6..8b3b849 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -54,15 +54,19 @@
 
 void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn)
 {
+	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
 	struct mlx4_cq *cq;
 
-	cq = radix_tree_lookup(&mlx4_priv(dev)->cq_table.tree,
-			       cqn & (dev->caps.num_cqs - 1));
+	read_lock(&cq_table->lock);
+
+	cq = radix_tree_lookup(&cq_table->tree, cqn & (dev->caps.num_cqs - 1));
 	if (!cq) {
 		mlx4_dbg(dev, "Completion event for bogus CQ %08x\n", cqn);
 		return;
 	}
 
+	read_unlock(&cq_table->lock);
+
 	++cq->arm_sn;
 
 	cq->comp(cq);
@@ -73,13 +77,13 @@ void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type)
 	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
 	struct mlx4_cq *cq;
 
-	spin_lock(&cq_table->lock);
+	read_lock(&cq_table->lock);
 
 	cq = radix_tree_lookup(&cq_table->tree, cqn & (dev->caps.num_cqs - 1));
 	if (cq)
 		atomic_inc(&cq->refcount);
 
-	spin_unlock(&cq_table->lock);
+	read_unlock(&cq_table->lock);
 
 	if (!cq) {
 		mlx4_warn(dev, "Async event for bogus CQ %08x\n", cqn);
@@ -256,9 +260,9 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
 	if (err)
 		return err;
 
-	spin_lock_irq(&cq_table->lock);
+	write_lock_irq(&cq_table->lock);
 	err = radix_tree_insert(&cq_table->tree, cq->cqn, cq);
-	spin_unlock_irq(&cq_table->lock);
+	write_unlock_irq(&cq_table->lock);
 	if (err)
 		goto err_icm;
 
@@ -297,9 +301,9 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
 	return 0;
 
 err_radix:
-	spin_lock_irq(&cq_table->lock);
+	write_lock_irq(&cq_table->lock);
 	radix_tree_delete(&cq_table->tree, cq->cqn);
-	spin_unlock_irq(&cq_table->lock);
+	write_unlock_irq(&cq_table->lock);
 
 err_icm:
 	mlx4_cq_free_icm(dev, cq->cqn);
@@ -320,9 +324,9 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
 
 	synchronize_irq(priv->eq_table.eq[cq->vector].irq);
 
-	spin_lock_irq(&cq_table->lock);
+	write_lock_irq(&cq_table->lock);
 	radix_tree_delete(&cq_table->tree, cq->cqn);
-	spin_unlock_irq(&cq_table->lock);
+	write_unlock_irq(&cq_table->lock);
 
 	if (atomic_dec_and_test(&cq->refcount))
 		complete(&cq->free);
@@ -337,7 +341,7 @@ int mlx4_init_cq_table(struct mlx4_dev *dev)
 	struct mlx4_cq_table *cq_table = &mlx4_priv(dev)->cq_table;
 	int err;
 
-	spin_lock_init(&cq_table->lock);
+	rwlock_init(&cq_table->lock);
 	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
 	if (mlx4_is_slave(dev))
 		return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index de10dbb..42e2348 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -642,7 +642,7 @@ struct mlx4_mr_table {
 
 struct mlx4_cq_table {
 	struct mlx4_bitmap	bitmap;
-	spinlock_t		lock;
+	rwlock_t		lock;
 	struct radix_tree_root	tree;
 	struct mlx4_icm_table	table;
 	struct mlx4_icm_table	cmpt_table;
-- 
1.7.6.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
