From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [RFC ib_srp-backport] ib_srp: bind fast IO failing to QP timeout
Date: Tue, 19 Mar 2013 11:16:57 +0100
Message-ID: <51483B19.1070201@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080100060507040804070101"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------080100060507040804070101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Bart,

now I've got my priority on SRP again.

I've also noticed that your ib_srp-backport doesn't fail the IO fast
enough. The fast_io_fail_tmo only comes into play after the QP is
already in timeout and the "terminate_rport_io" function is missing.

My idea is to use the QP retry count directly for fast IO failing. It is
at 7 by default and the QP timeout is at approx. 2s. The overall QP
timeout is at approx. 35s already (1+7 tries * 2s * 2, I guess). Using
only 3 retries I'm at approx 18s.

My patches introduce that parameter as module parameter as it is quite
difficult to set the QP from RTS to RTR again. Only there the QP timeout
parameters can be set.

My patch series isn't complete yet as paths aren't reconnected - they
are only failed fast bound to the overall QP timeout. But it should give
you an idea what I'm trying to do here.

What are your thought regarding this?

Attached patches:
ib_srp: register srp_fail_rport_io as terminate_rport_io
ib_srp: be quiet when failing SCSI commands
scsi_transport_srp: disable the fast_io_fail_tmo parameter
ib_srp: show the QP timeout and retry count in srp_host sysfs files
ib_srp: introduce qp_retry_cnt module parameter

Cheers,
Sebastian


Btw.: Before, I've hacked MD RAID-1 for high-performance replication as
DRBD is crap for our purposes. But that's worthless without a reliably
working transport.

--------------080100060507040804070101
Content-Type: text/plain; charset=UTF-8;
 name="0001-ib_srp-register-srp_fail_rport_io-as-terminate_rport_i.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ib_srp-register-srp_fail_rport_io-as-terminate_rport_i.";
 filename*1="txt"

>From c101d00fe529d845192dd6d5930a1b9c16c99b81 Mon Sep 17 00:00:00 2001
From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Wed, 13 Mar 2013 16:16:28 +0100
Subject: [PATCH 1/5] ib_srp: register srp_fail_rport_io as terminate_rport_io

We need to fail the IO fast in the selected time. So register the
missing terminate_rport_io function.

Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index dc49dc8..64644c5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -756,6 +756,29 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 	}
 }
 
+static void srp_fail_req(struct srp_target_port *target, struct srp_request *req)
+{
+	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
+
+	if (scmnd) {
+		srp_free_req(target, req, scmnd, 0);
+		scmnd->result = DID_TRANSPORT_FAILFAST << 16;
+		scmnd->scsi_done(scmnd);
+	}
+}
+
+static void srp_fail_rport_io(struct srp_rport *rport)
+{
+	struct srp_target_port *target = rport->lld_data;
+	int i;
+
+	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+		struct srp_request *req = &target->req_ring[i];
+		if (req->scmnd)
+			srp_fail_req(target, req);
+	}
+}
+
 static int srp_reconnect_target(struct srp_target_port *target)
 {
 	struct Scsi_Host *shost = target->scsi_host;
@@ -2700,6 +2723,7 @@ static void srp_remove_one(struct ib_device *device)
 
 static struct srp_function_template ib_srp_transport_functions = {
 	.rport_delete		 = srp_rport_delete,
+	.terminate_rport_io	 = srp_fail_rport_io,
 };
 
 static int __init srp_init_module(void)
-- 
1.7.9.5


--------------080100060507040804070101
Content-Type: text/plain; charset=UTF-8;
 name="0002-ib_srp-be-quiet-when-failing-SCSI-commands.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-ib_srp-be-quiet-when-failing-SCSI-commands.txt"

>From 06c3cc832a672856c416fee72705ea0448f23855 Mon Sep 17 00:00:00 2001
From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Wed, 13 Mar 2013 16:46:44 +0100
Subject: [PATCH 2/5] ib_srp: be quiet when failing SCSI commands

Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 64644c5..0607e5a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -750,6 +750,7 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
 
 	if (scmnd) {
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		srp_free_req(target, req, scmnd, 0);
 		scmnd->result = DID_RESET << 16;
 		scmnd->scsi_done(scmnd);
@@ -761,6 +762,7 @@ static void srp_fail_req(struct srp_target_port *target, struct srp_request *req
 	struct scsi_cmnd *scmnd = srp_claim_req(target, req, NULL);
 
 	if (scmnd) {
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		srp_free_req(target, req, scmnd, 0);
 		scmnd->result = DID_TRANSPORT_FAILFAST << 16;
 		scmnd->scsi_done(scmnd);
@@ -1526,6 +1528,7 @@ static int SRP_QUEUECOMMAND(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	int len;
 
 	if (unlikely(target->transport_offline)) {
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		scmnd->result = DID_NO_CONNECT << 16;
 		scmnd->scsi_done(scmnd);
 		return 0;
@@ -1934,6 +1937,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	else
 		ret = FAILED;
 
+	scmnd->request->cmd_flags |= REQ_QUIET;
 	srp_free_req(target, req, scmnd, 0);
 	scmnd->result = DID_ABORT << 16;
 	scmnd->scsi_done(scmnd);
-- 
1.7.9.5


--------------080100060507040804070101
Content-Type: text/plain; charset=UTF-8;
 name="0003-scsi_transport_srp-disable-the-fast_io_fail_tmo-parame.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-scsi_transport_srp-disable-the-fast_io_fail_tmo-parame.";
 filename*1="txt"

>From 2664578741f76f42a471736ffa990bb4f19c8d99 Mon Sep 17 00:00:00 2001
From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 18 Mar 2013 17:34:29 +0100
Subject: [PATCH 3/5] scsi_transport_srp: disable the fast_io_fail_tmo
 parameter

The fast_io_fail_tmo parameter only introduces further latency
after the QP is in timeout. The QP timeout is already at
2 s * (1 try + 7 retries) * 2. This is approx. 35 ms (found by
measurement on mlx4).

The overall QP timeout should adjustable instead (e.g. by exporting
the QP retry_cnt).

Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/scsi/scsi_transport_srp.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 239bb7a..be51bad 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -312,10 +312,7 @@ static void rport_dev_loss_timedout(struct work_struct *work)
  */
 void srp_start_tl_fail_timers(struct srp_rport *rport, int elapsed_jiffies)
 {
-	if (rport->fast_io_fail_tmo >= 0)
-		queue_delayed_work(system_long_wq, &rport->fast_io_fail_work,
-				      max_t(long, 1UL * rport->fast_io_fail_tmo
-					    * HZ - elapsed_jiffies, 0));
+	queue_delayed_work(system_long_wq, &rport->fast_io_fail_work, 0);
 	queue_delayed_work(system_long_wq, &rport->dev_loss_work,
 		   max_t(long, 1UL * rport->dev_loss_tmo * HZ - elapsed_jiffies,
 			 0));
-- 
1.7.9.5


--------------080100060507040804070101
Content-Type: text/plain; charset=UTF-8;
 name="0004-ib_srp-show-the-QP-timeout-and-retry-count-in-srp_host.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-ib_srp-show-the-QP-timeout-and-retry-count-in-srp_host.";
 filename*1="txt"

>From a0ff15e4e334a4d9e1539cbe3e8125d72287731f Mon Sep 17 00:00:00 2001
From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Mon, 18 Mar 2013 18:08:29 +0100
Subject: [PATCH 4/5] ib_srp: show the QP timeout and retry count in srp_host
 sysfs files

>From that we can calculate the overall QP timeout. The QP timeout
is at approx 2s by default and the retry count is at 7.
Now calculate 2s * (1+7) tries * 2, then you are at approx. 35s.

Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0607e5a..095c568 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2079,6 +2079,35 @@ static ssize_t show_allow_ext_sg(struct device *dev,
 	return sprintf(buf, "%s\n", target->allow_ext_sg ? "true" : "false");
 }
 
+static ssize_t show_qp_timeout_ms(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+	struct ib_qp *qp = target->qp;
+	struct ib_qp_attr qp_attr;
+	struct ib_qp_init_attr qpi_attr;  /* useless, but required */
+	uint64_t T_tr_ms;
+
+	if (!qp || ib_query_qp(qp, &qp_attr, IB_QP_TIMEOUT, &qpi_attr) != 0)
+		return -EINVAL;
+	T_tr_ms = 4096 * (1ULL << qp_attr.timeout);
+	do_div(T_tr_ms, NSEC_PER_MSEC);
+	return sprintf(buf, "%llu\n", T_tr_ms);
+}
+
+static ssize_t show_qp_retries(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+	struct ib_qp *qp = target->qp;
+	struct ib_qp_attr qp_attr;
+	struct ib_qp_init_attr qpi_attr;  /* useless, but required */
+
+	if (!qp || ib_query_qp(qp, &qp_attr, IB_QP_RETRY_CNT, &qpi_attr) != 0)
+		return -EINVAL;
+	return sprintf(buf, "%u\n", qp_attr.retry_cnt);
+}
+
 static DEVICE_ATTR(id_ext,	    S_IRUGO, show_id_ext,	   NULL);
 static DEVICE_ATTR(ioc_guid,	    S_IRUGO, show_ioc_guid,	   NULL);
 static DEVICE_ATTR(service_id,	    S_IRUGO, show_service_id,	   NULL);
@@ -2091,6 +2120,8 @@ static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
 static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
 static DEVICE_ATTR(allow_ext_sg,    S_IRUGO, show_allow_ext_sg,    NULL);
+static DEVICE_ATTR(qp_timeout_ms,   S_IRUGO, show_qp_timeout_ms,   NULL);
+static DEVICE_ATTR(qp_retries,      S_IRUGO, show_qp_retries,      NULL);
 
 static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_id_ext,
@@ -2105,6 +2136,8 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_local_ib_device,
 	&dev_attr_cmd_sg_entries,
 	&dev_attr_allow_ext_sg,
+	&dev_attr_qp_timeout_ms,
+	&dev_attr_qp_retries,
 	NULL
 };
 
-- 
1.7.9.5


--------------080100060507040804070101
Content-Type: text/plain; charset=UTF-8;
 name="0005-ib_srp-introduce-qp_retry_cnt-module-parameter.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0005-ib_srp-introduce-qp_retry_cnt-module-parameter.txt"

>From 9988a55a2ea7357bef32b26c05566d51e49c8c2b Mon Sep 17 00:00:00 2001
From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date: Tue, 19 Mar 2013 09:41:09 +0100
Subject: [PATCH 5/5] ib_srp: introduce qp_retry_cnt module parameter

With that it is possible to reduce the overall QP timeout. If it is
set, then we can fail IO faster. This replaces the fast_io_fail_tmo
functionality as we can get much lower and calculateable timeouts.

Signed-off-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   16 ++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    3 +++
 drivers/scsi/scsi_transport_srp.c   |    3 ++-
 include/scsi/scsi_transport_srp.h   |    1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 095c568..c240fa7 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -75,6 +75,8 @@ static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
 static int topspin_workarounds = 1;
+static unsigned int qp_retry_cnt;
+static bool qp_retry_set = false;
 
 module_param(srp_sg_tablesize, uint, 0444);
 MODULE_PARM_DESC(srp_sg_tablesize, "Deprecated name for cmd_sg_entries");
@@ -95,6 +97,10 @@ module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
+module_param(qp_retry_cnt, uint, 0444);
+MODULE_PARM_DESC(qp_retry_cnt,
+		 "Number of qp retries, set this for fast IO failing (default is 7, max is 19)");
+
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
@@ -1718,6 +1724,7 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 		goto error_free;
 
 	target->rq_tmo_jiffies = srp_compute_rq_tmo(qp_attr, attr_mask);
+	qp_attr->retry_cnt = qp_retry_cnt;
 
 	ret = ib_modify_qp(target->qp, qp_attr, attr_mask);
 	if (ret)
@@ -2183,6 +2190,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	}
 
 	rport->lld_data = target;
+	rport->qp_retry_set = qp_retry_set;
 	target->rport = rport;
 
 	return 0;
@@ -2791,6 +2799,14 @@ static int __init srp_init_module(void)
 		indirect_sg_entries = cmd_sg_entries;
 	}
 
+	if (!qp_retry_cnt)
+		qp_retry_cnt = SRP_DEF_QP_RETRIES;
+	else
+		qp_retry_set = true;
+
+	if (qp_retry_cnt > SRP_MAX_QP_RETRIES)
+		qp_retry_cnt = SRP_MAX_QP_RETRIES;
+
 	ret = srp_transport_init();
 	if (ret) {
 		pr_err("SRP transport initialization failed\n");
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 1e8d538..ad43615 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -57,6 +57,9 @@ enum {
 	SRP_MAX_LUN		= 512,
 	SRP_DEF_SG_TABLESIZE	= 12,
 
+	SRP_DEF_QP_RETRIES      = 7,
+	SRP_MAX_QP_RETRIES      = 19,
+
 	SRP_RQ_SHIFT    	= 6,
 	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
 
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index be51bad..347d231 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -312,7 +312,8 @@ static void rport_dev_loss_timedout(struct work_struct *work)
  */
 void srp_start_tl_fail_timers(struct srp_rport *rport, int elapsed_jiffies)
 {
-	queue_delayed_work(system_long_wq, &rport->fast_io_fail_work, 0);
+	if (rport->qp_retry_set)
+		queue_delayed_work(system_long_wq, &rport->fast_io_fail_work, 0);
 	queue_delayed_work(system_long_wq, &rport->dev_loss_work,
 		   max_t(long, 1UL * rport->dev_loss_tmo * HZ - elapsed_jiffies,
 			 0));
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index f74b715..aa9931e 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -25,6 +25,7 @@ struct srp_rport {
 
 	void			*lld_data;	/* LLD private data */
 
+	bool			qp_retry_set;
 	int			fast_io_fail_tmo;
 	unsigned		dev_loss_tmo;
 	struct delayed_work	fast_io_fail_work;
-- 
1.7.9.5


--------------080100060507040804070101--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
