From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 04/14] ib_srp: Set block layer timeout
Date: Thu, 1 Dec 2011 19:59:11 +0100
Message-ID: <201112011959.11956.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201112011954.25811.bvanassche-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Make sure that the default block layer timeout is above the
InfiniBand transport layer timeout. The default block layer
timeout is 30 seconds. Typical values for the QP local ack
timeout and retry count are 19 and 7 respectively, which means
that it can take up to 60.1 seconds before a HCA submits an
error completion. The block layer timeout must be larger than
the transport layer timeout because otherwise it can happen
that an SRP response is received after the SCSI layer has
already killed a command.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   30 ++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    1 +
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2e0169b..0e2353d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1372,6 +1372,17 @@ err:
 	return -ENOMEM;
 }
 
+static int srp_slave_alloc(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct srp_target_port *target = host_to_target(shost);
+
+	if (!WARN_ON(target->rq_tmo_jiffies == 0))
+		blk_queue_rq_timeout(sdev->request_queue,
+				     target->rq_tmo_jiffies);
+	return 0;
+}
+
 static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 			       struct srp_login_rsp *lrsp,
 			       struct srp_target_port *target)
@@ -1431,6 +1442,24 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 	if (ret)
 		goto error_free;
 
+	if (!WARN_ON((attr_mask & (IB_QP_TIMEOUT | IB_QP_RETRY_CNT)) == 0)) {
+		uint64_t T_tr_ns, max_compl_time_ms;
+
+		/*
+		 * Set target->rq_tmo_jiffies to one second more than the
+		 * largest time it can take before an error completion is
+		 * generated.
+		 */
+		T_tr_ns = 1ULL << (12 + qp_attr->timeout);
+		max_compl_time_ms = qp_attr->retry_cnt * 4 * T_tr_ns;
+		do_div(max_compl_time_ms, 1000 * 1000);
+		target->rq_tmo_jiffies =
+			msecs_to_jiffies(max_compl_time_ms + 1000);
+		pr_debug("max. IB completion time = %lld ms; block layer"
+			 " timeout = %d jiffies\n", max_compl_time_ms,
+			 target->rq_tmo_jiffies);
+	}
+
 	ret = ib_modify_qp(target->qp, qp_attr, attr_mask);
 	if (ret)
 		goto error_free;
@@ -1821,6 +1850,7 @@ static struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
+	.slave_alloc			= srp_slave_alloc,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.eh_abort_handler		= srp_abort,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 020caf0..f010bd9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -138,6 +138,7 @@ struct srp_target_port {
 	u32			lkey;
 	u32			rkey;
 	enum srp_target_state	state;
+	u32			rq_tmo_jiffies;
 	unsigned int		max_iu_len;
 	unsigned int		cmd_sg_cnt;
 	unsigned int		indirect_size;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
