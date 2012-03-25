From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 01/15] ib_srp: Enlarge block layer timeout
Date: Sun, 25 Mar 2012 14:47:06 +0000
Message-ID: <1385797.u8D4MDGaaX@asus>
References: <5207288.nSt5MkVMpO@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5207288.nSt5MkVMpO@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Enlarge the block layer timeout for disks such that it is above
the InfiniBand transport layer timeout. This is necessary to avoid
that an SRP response is received after the SCSI layer has already
killed the associated SCSI command.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   45 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index bcbf22e..5543c2b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1372,6 +1372,33 @@ err:
 	return -ENOMEM;
 }
 
+static uint32_t srp_compute_rq_tmo(struct ib_qp_attr *qp_attr, int attr_mask)
+{
+	uint64_t T_tr_ns, max_compl_time_ms;
+	uint32_t rq_tmo_jiffies;
+
+	/*
+	 * According to section 11.2.4.2 in the IBTA spec (Modify Queue Pair,
+	 * table 91), both the QP timeout and the retry count have to be set
+	 * for RC QP's during the RTR to RTS transition.
+	 */
+	WARN_ON((attr_mask & (IB_QP_TIMEOUT | IB_QP_RETRY_CNT)) !=
+		(IB_QP_TIMEOUT | IB_QP_RETRY_CNT));
+
+	/*
+	 * Set target->rq_tmo_jiffies to one second more than the largest time
+	 * it can take before an error completion is generated. See also
+	 * C9-140..C9-142 in the IBTA spec for more information about how to
+	 * convert the QP Local ACK Timeout value to nanoseconds.
+	 */
+	T_tr_ns = 4096 * (1ULL << qp_attr->timeout);
+	max_compl_time_ms = qp_attr->retry_cnt * 4 * T_tr_ns;
+	do_div(max_compl_time_ms, NSEC_PER_MSEC);
+	rq_tmo_jiffies = msecs_to_jiffies(max_compl_time_ms + 1000);
+
+	return rq_tmo_jiffies;
+}
+
 static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 			       struct srp_login_rsp *lrsp,
 			       struct srp_target_port *target)
@@ -1431,6 +1458,8 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 	if (ret)
 		goto error_free;
 
+	target->rq_tmo_jiffies = srp_compute_rq_tmo(qp_attr, attr_mask);
+
 	ret = ib_modify_qp(target->qp, qp_attr, attr_mask);
 	if (ret)
 		goto error_free;
@@ -1689,6 +1718,21 @@ static int srp_reset_host(struct scsi_cmnd *scmnd)
 	return ret;
 }
 
+static int srp_slave_configure(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct srp_target_port *target = host_to_target(shost);
+	struct request_queue *q = sdev->request_queue;
+	unsigned long timeout;
+
+	if (sdev->type == TYPE_DISK) {
+		timeout = max_t(unsigned, 30 * HZ, target->rq_tmo_jiffies);
+		blk_queue_rq_timeout(q, timeout);
+	}
+
+	return 0;
+}
+
 static ssize_t show_id_ext(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -1821,6 +1865,7 @@ static struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
+	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.eh_abort_handler		= srp_abort,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 020caf0..e3a6304 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -163,6 +163,8 @@ struct srp_target_port {
 	struct ib_sa_query     *path_query;
 	int			path_query_id;
 
+	u32			rq_tmo_jiffies;
+
 	struct ib_cm_id	       *cm_id;
 
 	int			max_ti_iu_len;
-- 
1.7.7


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
