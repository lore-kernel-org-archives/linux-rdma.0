From: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH for-4.1 09/11] RDMA/ocrdma: Add CQ usage statistics counters
Date: Sat, 16 May 2015 13:21:47 +0530
Message-ID: <1431762709-20740-10-git-send-email-selvin.xavier@avagotech.com>
References: <1431762709-20740-1-git-send-email-selvin.xavier@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431762709-20740-1-git-send-email-selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Meghana Cheripady <meghana.cheripady-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>

Add counters for tracking the CQ usage by applications.

Signed-off-by: Meghana Cheripady <meghana.cheripady-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |  2 ++
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |  8 ++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 15 +++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |  2 ++
 4 files changed, 27 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index ee9e335..8782e1f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -290,6 +290,8 @@ struct ocrdma_dev {
 	struct dentry *dir;
 	atomic_t async_err_stats[OCRDMA_MAX_ASYNC_ERRORS];
 	atomic_t cqe_err_stats[OCRDMA_MAX_CQE_ERR];
+	atomic_t act_cq_stats;
+	atomic_t th_cq_stats;
 	struct ocrdma_pd_resource_mgr *pd_mgr;
 };
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 319675c..596d8c9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1720,6 +1720,7 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 	struct ocrdma_create_cq *cmd;
 	struct ocrdma_create_cq_rsp *rsp;
 	u32 hw_pages, cqe_size, page_size, cqe_count;
+	int act_cq_cnt, th_cq_cnt;
 
 	if (entries > dev->attr.max_cqe) {
 		pr_err("%s(%d) max_cqe=0x%x, requester_cqe=0x%x\n",
@@ -1808,6 +1809,13 @@ int ocrdma_mbx_create_cq(struct ocrdma_dev *dev, struct ocrdma_cq *cq,
 
 	rsp = (struct ocrdma_create_cq_rsp *)cmd;
 	cq->id = (u16) (rsp->rsp.cq_id & OCRDMA_CREATE_CQ_RSP_CQ_ID_MASK);
+
+	atomic_inc(&dev->act_cq_stats);
+	act_cq_cnt = atomic_read(&dev->act_cq_stats);
+	th_cq_cnt = atomic_read(&dev->th_cq_stats);
+	if (th_cq_cnt < act_cq_cnt)
+		atomic_set(&dev->th_cq_stats, act_cq_cnt);
+
 	kfree(cmd);
 	return 0;
 mbx_err:
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index 48d7ef5..47fef14 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -146,6 +146,8 @@ static char *ocrdma_resource_stats(struct ocrdma_dev *dev)
 				(u64)rsrc_stats->phy_mr);
 	pcur += ocrdma_add_stat(stats, pcur, "active_mw",
 				(u64)rsrc_stats->mw);
+	pcur += ocrdma_add_stat(stats, pcur, "active_cq_usage_stats",
+				(u64)atomic_read(&dev->act_cq_stats));
 
 	/* Print the threshold stats */
 	rsrc_stats = &rdma_stats->th_rsrc_stats;
@@ -200,6 +202,8 @@ static char *ocrdma_resource_stats(struct ocrdma_dev *dev)
 				(u64)rsrc_stats->phy_mr);
 	pcur += ocrdma_add_stat(stats, pcur, "threshold_mw",
 				(u64)rsrc_stats->mw);
+	pcur += ocrdma_add_stat(stats, pcur, "threshold_cq_usage_stats",
+				(u64)atomic_read(&dev->th_cq_stats));
 	return stats;
 }
 
@@ -745,6 +749,16 @@ static const struct file_operations ocrdma_dbg_ops = {
 	.write = ocrdma_dbgfs_ops_write,
 };
 
+static void ocrdma_init_cq_stats(struct ocrdma_dev *dev)
+{
+	int i, cq_cnt = 0;
+
+	for (i = 0; i < dev->eq_cnt; i++)
+		cq_cnt += dev->eq_tbl[i].cq_cnt;
+	atomic_set(&dev->act_cq_stats, cq_cnt);
+	atomic_set(&dev->th_cq_stats, cq_cnt);
+}
+
 void ocrdma_add_port_stats(struct ocrdma_dev *dev)
 {
 	if (!ocrdma_dbgfs_dir)
@@ -828,6 +842,7 @@ void ocrdma_add_port_stats(struct ocrdma_dev *dev)
 		goto err;
 
 	mutex_init(&dev->stats_lock);
+	ocrdma_init_cq_stats(dev);
 
 	return;
 err:
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 9dcb660..48ec56f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1119,6 +1119,8 @@ int ocrdma_destroy_cq(struct ib_cq *ibcq)
 				dev->nic_info.db_page_size);
 	}
 
+	atomic_dec(&dev->act_cq_stats);
+
 	kfree(cq);
 	return 0;
 }
-- 
2.2.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
