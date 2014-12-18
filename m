From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/14] RDMA/ocrdma: DebugFs enhancments for ocrdma driver.
Date: Thu, 18 Dec 2014 14:12:59 +0530
Message-ID: <8ae00867-1a39-46ea-abe1-353d4ce45b35@CMEXHTCAS1.ad.emulex.com>
References: <1418892188-6623-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418892188-6623-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

        1. Add statistics counters for error cqes.
        2. Add file ("reset_stats") to reset rdma stats in Debugfs.

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Mitesh Ahuja <mitesh.ahuja-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma.h       |    4 +
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    |    3 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h   |    8 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c |  161 +++++++++++++++++++++++++++
 drivers/infiniband/hw/ocrdma/ocrdma_stats.h |    4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    7 +
 6 files changed, 184 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 013cc7e..933b38a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -271,7 +271,11 @@ struct ocrdma_dev {
 	struct ocrdma_stats rx_qp_err_stats;
 	struct ocrdma_stats tx_dbg_stats;
 	struct ocrdma_stats rx_dbg_stats;
+	struct ocrdma_stats driver_stats;
+	struct ocrdma_stats reset_stats;
 	struct dentry *dir;
+	atomic_t async_err_stats[OCRDMA_MAX_ASYNC_ERRORS];
+	atomic_t cqe_err_stats[OCRDMA_MAX_CQE_ERR];
 	struct ocrdma_pd_resource_mgr *pd_mgr;
 };
 
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 1d47700..8126c88 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -734,6 +734,9 @@ static void ocrdma_dispatch_ibevent(struct ocrdma_dev *dev,
 		break;
 	}
 
+	if (type < OCRDMA_MAX_ASYNC_ERRORS)
+		atomic_inc(&dev->async_err_stats[type]);
+
 	if (qp_event) {
 		if (qp->ibqp.event_handler)
 			qp->ibqp.event_handler(&ib_evt, qp->ibqp.qp_context);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
index e252f1b..6ba9939 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_sli.h
@@ -443,7 +443,9 @@ enum OCRDMA_ASYNC_EVENT_TYPE {
 	OCRDMA_DEVICE_FATAL_EVENT	= 0x08,
 	OCRDMA_SRQCAT_ERROR		= 0x0E,
 	OCRDMA_SRQ_LIMIT_EVENT		= 0x0F,
-	OCRDMA_QP_LAST_WQE_EVENT	= 0x10
+	OCRDMA_QP_LAST_WQE_EVENT	= 0x10,
+
+	OCRDMA_MAX_ASYNC_ERRORS
 };
 
 /* mailbox command request and responses */
@@ -1630,7 +1632,9 @@ enum OCRDMA_CQE_STATUS {
 	OCRDMA_CQE_INV_EEC_STATE_ERR,
 	OCRDMA_CQE_FATAL_ERR,
 	OCRDMA_CQE_RESP_TIMEOUT_ERR,
-	OCRDMA_CQE_GENERAL_ERR
+	OCRDMA_CQE_GENERAL_ERR,
+
+	OCRDMA_MAX_CQE_ERR
 };
 
 enum {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
index f0a3a59..a8822a2 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
@@ -485,6 +485,111 @@ static char *ocrdma_rx_dbg_stats(struct ocrdma_dev *dev)
 	return dev->stats_mem.debugfs_mem;
 }
 
+static char *ocrdma_driver_dbg_stats(struct ocrdma_dev *dev)
+{
+	char *stats = dev->stats_mem.debugfs_mem, *pcur;
+
+
+	memset(stats, 0, (OCRDMA_MAX_DBGFS_MEM));
+
+	pcur = stats;
+	pcur += ocrdma_add_stat(stats, pcur, "async_cq_err",
+				(u64)(dev->async_err_stats
+				[OCRDMA_CQ_ERROR].counter));
+	pcur += ocrdma_add_stat(stats, pcur, "async_cq_overrun_err",
+				(u64)dev->async_err_stats
+				[OCRDMA_CQ_OVERRUN_ERROR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "async_cq_qpcat_err",
+				(u64)dev->async_err_stats
+				[OCRDMA_CQ_QPCAT_ERROR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "async_qp_access_err",
+				(u64)dev->async_err_stats
+				[OCRDMA_QP_ACCESS_ERROR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "async_qp_commm_est_evt",
+				(u64)dev->async_err_stats
+				[OCRDMA_QP_COMM_EST_EVENT].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "async_sq_drained_evt",
+				(u64)dev->async_err_stats
+				[OCRDMA_SQ_DRAINED_EVENT].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "async_dev_fatal_evt",
+				(u64)dev->async_err_stats
+				[OCRDMA_DEVICE_FATAL_EVENT].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "async_srqcat_err",
+				(u64)dev->async_err_stats
+				[OCRDMA_SRQCAT_ERROR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "async_srq_limit_evt",
+				(u64)dev->async_err_stats
+				[OCRDMA_SRQ_LIMIT_EVENT].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "async_qp_last_wqe_evt",
+				(u64)dev->async_err_stats
+				[OCRDMA_QP_LAST_WQE_EVENT].counter);
+
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_loc_len_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_LOC_LEN_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_loc_qp_op_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_LOC_QP_OP_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_loc_eec_op_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_LOC_EEC_OP_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_loc_prot_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_LOC_PROT_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_wr_flush_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_WR_FLUSH_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_mw_bind_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_MW_BIND_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_bad_resp_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_BAD_RESP_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_loc_access_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_LOC_ACCESS_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_rem_inv_req_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_REM_INV_REQ_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_rem_access_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_REM_ACCESS_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_rem_op_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_REM_OP_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_retry_exc_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_RETRY_EXC_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_rnr_retry_exc_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_RNR_RETRY_EXC_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_loc_rdd_viol_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_LOC_RDD_VIOL_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_rem_inv_rd_req_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_REM_INV_RD_REQ_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_rem_abort_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_REM_ABORT_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_inv_eecn_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_INV_EECN_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_inv_eec_state_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_INV_EEC_STATE_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_fatal_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_FATAL_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_resp_timeout_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_RESP_TIMEOUT_ERR].counter);
+	pcur += ocrdma_add_stat(stats, pcur, "cqe_general_err",
+				(u64)dev->cqe_err_stats
+				[OCRDMA_CQE_GENERAL_ERR].counter);
+	return stats;
+}
+
 static void ocrdma_update_stats(struct ocrdma_dev *dev)
 {
 	ulong now = jiffies, secs;
@@ -513,6 +618,46 @@ static void ocrdma_update_stats(struct ocrdma_dev *dev)
 	}
 }
 
+static ssize_t ocrdma_dbgfs_ops_write(struct file *filp,
+					const char __user *buffer,
+					size_t count, loff_t *ppos)
+{
+	char tmp_str[32];
+	long reset;
+	int status = 0;
+	struct ocrdma_stats *pstats = filp->private_data;
+	struct ocrdma_dev *dev = pstats->dev;
+
+	if (count > 32)
+		goto err;
+
+	if (copy_from_user(tmp_str, buffer, count))
+		goto err;
+
+	tmp_str[count-1] = '\0';
+	if (kstrtol(tmp_str, 10, &reset))
+		goto err;
+
+	switch (pstats->type) {
+	case OCRDMA_RESET_STATS:
+		if (reset) {
+			status = ocrdma_mbx_rdma_stats(dev, true);
+			if (status) {
+				pr_err("Failed to reset stats = %d",
+						status) ;
+				goto err;
+			}
+		}
+		break;
+	default:
+		goto err;
+	}
+
+	return count;
+err:
+	return -EFAULT;
+}
+
 int ocrdma_pma_counters(struct ocrdma_dev *dev,
 			struct ib_mad *out_mad)
 {
@@ -573,6 +718,9 @@ static ssize_t ocrdma_dbgfs_ops_read(struct file *filp, char __user *buffer,
 	case OCRDMA_RX_DBG_STATS:
 		data = ocrdma_rx_dbg_stats(dev);
 		break;
+	case OCRDMA_DRV_STATS:
+		data = ocrdma_driver_dbg_stats(dev);
+		break;
 
 	default:
 		status = -EFAULT;
@@ -595,6 +743,7 @@ static const struct file_operations ocrdma_dbg_ops = {
 	.owner = THIS_MODULE,
 	.open = simple_open,
 	.read = ocrdma_dbgfs_ops_read,
+	.write = ocrdma_dbgfs_ops_write,
 };
 
 void ocrdma_add_port_stats(struct ocrdma_dev *dev)
@@ -663,6 +812,18 @@ void ocrdma_add_port_stats(struct ocrdma_dev *dev)
 				 &dev->rx_dbg_stats, &ocrdma_dbg_ops))
 		goto err;
 
+	dev->driver_stats.type = OCRDMA_DRV_STATS;
+	dev->driver_stats.dev = dev;
+	if (!debugfs_create_file("driver_dbg_stats", S_IRUSR, dev->dir,
+					&dev->driver_stats, &ocrdma_dbg_ops))
+		goto err;
+
+	dev->reset_stats.type = OCRDMA_RESET_STATS;
+	dev->reset_stats.dev = dev;
+	if (!debugfs_create_file("reset_stats", S_IRUSR, dev->dir,
+				&dev->reset_stats, &ocrdma_dbg_ops))
+		goto err;
+
 	/* Now create dma_mem for stats mbx command */
 	if (!ocrdma_alloc_stats_mem(dev))
 		goto err;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.h b/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
index 89afe06..091edd6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.h
@@ -43,7 +43,9 @@ enum OCRDMA_STATS_TYPE {
 	OCRDMA_RXQP_ERRSTATS,
 	OCRDMA_TXQP_ERRSTATS,
 	OCRDMA_TX_DBG_STATS,
-	OCRDMA_RX_DBG_STATS
+	OCRDMA_RX_DBG_STATS,
+	OCRDMA_DRV_STATS,
+	OCRDMA_RESET_STATS
 };
 
 void ocrdma_rem_debugfs(void);
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 8681a24..75c7276 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2594,8 +2594,11 @@ static bool ocrdma_poll_err_scqe(struct ocrdma_qp *qp,
 				 bool *polled, bool *stop)
 {
 	bool expand;
+	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
 	int status = (le32_to_cpu(cqe->flags_status_srcqpn) &
 		OCRDMA_CQE_STATUS_MASK) >> OCRDMA_CQE_STATUS_SHIFT;
+	if (status < OCRDMA_MAX_CQE_ERR)
+		atomic_inc(&dev->cqe_err_stats[status]);
 
 	/* when hw sq is empty, but rq is not empty, so we continue
 	 * to keep the cqe in order to get the cq event again.
@@ -2714,6 +2717,10 @@ static bool ocrdma_poll_err_rcqe(struct ocrdma_qp *qp, struct ocrdma_cqe *cqe,
 				int status)
 {
 	bool expand;
+	struct ocrdma_dev *dev = get_ocrdma_dev(qp->ibqp.device);
+
+	if (status < OCRDMA_MAX_CQE_ERR)
+		atomic_inc(&dev->cqe_err_stats[status]);
 
 	/* when hw_rq is empty, but wq is not empty, so continue
 	 * to keep the cqe to get the cq event again.
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
