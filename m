From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 10/10] IB/srp: Make queue size configurable
Date: Sat, 26 Oct 2013 14:40:37 +0200
Message-ID: <526BB845.2070501@acm.org>
References: <526BB5AC.7010601@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <526BB5AC.7010601-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Certain storage configurations, e.g. a sufficiently large array of
hard disks in a RAID configuration, need a queue depth above 64 to
achieve optimal performance. Hence make the queue depth configurable.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Acked-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Tested-by: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Konrad Grzybowski <konrad.grzybowski-XLFqaoR9dsI@public.gmane.org>
---
 Documentation/ABI/stable/sysfs-driver-ib_srp |   4 +
 drivers/infiniband/ulp/srp/ib_srp.c          | 125 ++++++++++++++++++++-------
 drivers/infiniband/ulp/srp/ib_srp.h          |  17 ++--
 3 files changed, 107 insertions(+), 39 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
index b95067e..b9688de 100644
--- a/Documentation/ABI/stable/sysfs-driver-ib_srp
+++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
@@ -63,6 +63,10 @@ Description:	Interface for making ib_srp connect to a new target.
 		  over multiple CPU's.
 		* tl_retry_count, a number in the range 2..7 specifying the
 		  IB RC retry count.
+		* queue_size, the maximum number of commands that the
+		  initiator is allowed to queue per SCSI host. The default
+		  value for this parameter is 62. The lowest supported value
+		  is 2.
 
 What:		/sys/class/infiniband_srp/srp-<hca>-<port_number>/ibdev
 Date:		January 2, 2006
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fdc0bc1..032fe2b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -299,16 +299,16 @@ static int srp_create_target_ib(struct srp_target_port *target)
 		return -ENOMEM;
 
 	recv_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-			       srp_recv_completion, NULL, target, SRP_RQ_SIZE,
-			       target->comp_vector);
+			       srp_recv_completion, NULL, target,
+			       target->queue_size, target->comp_vector);
 	if (IS_ERR(recv_cq)) {
 		ret = PTR_ERR(recv_cq);
 		goto err;
 	}
 
 	send_cq = ib_create_cq(target->srp_host->srp_dev->dev,
-			       srp_send_completion, NULL, target, SRP_SQ_SIZE,
-			       target->comp_vector);
+			       srp_send_completion, NULL, target,
+			       target->queue_size, target->comp_vector);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
@@ -317,8 +317,8 @@ static int srp_create_target_ib(struct srp_target_port *target)
 	ib_req_notify_cq(recv_cq, IB_CQ_NEXT_COMP);
 
 	init_attr->event_handler       = srp_qp_event;
-	init_attr->cap.max_send_wr     = SRP_SQ_SIZE;
-	init_attr->cap.max_recv_wr     = SRP_RQ_SIZE;
+	init_attr->cap.max_send_wr     = target->queue_size;
+	init_attr->cap.max_recv_wr     = target->queue_size;
 	init_attr->cap.max_recv_sge    = 1;
 	init_attr->cap.max_send_sge    = 1;
 	init_attr->sq_sig_type         = IB_SIGNAL_ALL_WR;
@@ -364,6 +364,10 @@ err:
 	return ret;
 }
 
+/*
+ * Note: this function may be called without srp_alloc_iu_bufs() having been
+ * invoked. Hence the target->[rt]x_ring checks.
+ */
 static void srp_free_target_ib(struct srp_target_port *target)
 {
 	int i;
@@ -375,10 +379,18 @@ static void srp_free_target_ib(struct srp_target_port *target)
 	target->qp = NULL;
 	target->send_cq = target->recv_cq = NULL;
 
-	for (i = 0; i < SRP_RQ_SIZE; ++i)
-		srp_free_iu(target->srp_host, target->rx_ring[i]);
-	for (i = 0; i < SRP_SQ_SIZE; ++i)
-		srp_free_iu(target->srp_host, target->tx_ring[i]);
+	if (target->rx_ring) {
+		for (i = 0; i < target->queue_size; ++i)
+			srp_free_iu(target->srp_host, target->rx_ring[i]);
+		kfree(target->rx_ring);
+		target->rx_ring = NULL;
+	}
+	if (target->tx_ring) {
+		for (i = 0; i < target->queue_size; ++i)
+			srp_free_iu(target->srp_host, target->tx_ring[i]);
+		kfree(target->tx_ring);
+		target->tx_ring = NULL;
+	}
 }
 
 static void srp_path_rec_completion(int status,
@@ -564,7 +576,11 @@ static void srp_free_req_data(struct srp_target_port *target)
 	struct srp_request *req;
 	int i;
 
-	for (i = 0, req = target->req_ring; i < SRP_CMD_SQ_SIZE; ++i, ++req) {
+	if (!target->req_ring)
+		return;
+
+	for (i = 0; i < target->req_ring_size; ++i) {
+		req = &target->req_ring[i];
 		kfree(req->fmr_list);
 		kfree(req->map_page);
 		if (req->indirect_dma_addr) {
@@ -574,6 +590,9 @@ static void srp_free_req_data(struct srp_target_port *target)
 		}
 		kfree(req->indirect_desc);
 	}
+
+	kfree(target->req_ring);
+	target->req_ring = NULL;
 }
 
 static int srp_alloc_req_data(struct srp_target_port *target)
@@ -586,7 +605,12 @@ static int srp_alloc_req_data(struct srp_target_port *target)
 
 	INIT_LIST_HEAD(&target->free_reqs);
 
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+	target->req_ring = kzalloc(target->req_ring_size *
+				   sizeof(*target->req_ring), GFP_KERNEL);
+	if (!target->req_ring)
+		goto out;
+
+	for (i = 0; i < target->req_ring_size; ++i) {
 		req = &target->req_ring[i];
 		req->fmr_list = kmalloc(target->cmd_sg_cnt * sizeof(void *),
 					GFP_KERNEL);
@@ -811,7 +835,7 @@ static void srp_terminate_io(struct srp_rport *rport)
 	struct srp_target_port *target = rport->lld_data;
 	int i;
 
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+	for (i = 0; i < target->req_ring_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		srp_finish_req(target, req, DID_TRANSPORT_FAILFAST << 16);
 	}
@@ -848,13 +872,13 @@ static int srp_rport_reconnect(struct srp_rport *rport)
 	else
 		srp_create_target_ib(target);
 
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+	for (i = 0; i < target->req_ring_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		srp_finish_req(target, req, DID_RESET << 16);
 	}
 
 	INIT_LIST_HEAD(&target->free_tx);
-	for (i = 0; i < SRP_SQ_SIZE; ++i)
+	for (i = 0; i < target->queue_size; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
 	if (ret == 0)
@@ -1562,11 +1586,24 @@ err_unlock:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
+/*
+ * Note: the resources allocated in this function are freed in
+ * srp_free_target_ib().
+ */
 static int srp_alloc_iu_bufs(struct srp_target_port *target)
 {
 	int i;
 
-	for (i = 0; i < SRP_RQ_SIZE; ++i) {
+	target->rx_ring = kzalloc(target->queue_size * sizeof(*target->rx_ring),
+				  GFP_KERNEL);
+	if (!target->rx_ring)
+		goto err_no_ring;
+	target->tx_ring = kzalloc(target->queue_size * sizeof(*target->tx_ring),
+				  GFP_KERNEL);
+	if (!target->tx_ring)
+		goto err_no_ring;
+
+	for (i = 0; i < target->queue_size; ++i) {
 		target->rx_ring[i] = srp_alloc_iu(target->srp_host,
 						  target->max_ti_iu_len,
 						  GFP_KERNEL, DMA_FROM_DEVICE);
@@ -1574,7 +1611,7 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 			goto err;
 	}
 
-	for (i = 0; i < SRP_SQ_SIZE; ++i) {
+	for (i = 0; i < target->queue_size; ++i) {
 		target->tx_ring[i] = srp_alloc_iu(target->srp_host,
 						  target->max_iu_len,
 						  GFP_KERNEL, DMA_TO_DEVICE);
@@ -1587,16 +1624,18 @@ static int srp_alloc_iu_bufs(struct srp_target_port *target)
 	return 0;
 
 err:
-	for (i = 0; i < SRP_RQ_SIZE; ++i) {
+	for (i = 0; i < target->queue_size; ++i) {
 		srp_free_iu(target->srp_host, target->rx_ring[i]);
-		target->rx_ring[i] = NULL;
-	}
-
-	for (i = 0; i < SRP_SQ_SIZE; ++i) {
 		srp_free_iu(target->srp_host, target->tx_ring[i]);
-		target->tx_ring[i] = NULL;
 	}
 
+
+err_no_ring:
+	kfree(target->tx_ring);
+	target->tx_ring = NULL;
+	kfree(target->rx_ring);
+	target->rx_ring = NULL;
+
 	return -ENOMEM;
 }
 
@@ -1647,6 +1686,9 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 		target->scsi_host->can_queue
 			= min(target->req_lim - SRP_TSK_MGMT_SQ_SIZE,
 			      target->scsi_host->can_queue);
+		target->scsi_host->cmd_per_lun
+			= min_t(int, target->scsi_host->can_queue,
+				target->scsi_host->cmd_per_lun);
 	} else {
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "Unhandled RSP opcode %#x\n", lrsp->opcode);
@@ -1654,7 +1696,7 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 		goto error;
 	}
 
-	if (!target->rx_ring[0]) {
+	if (!target->rx_ring) {
 		ret = srp_alloc_iu_bufs(target);
 		if (ret)
 			goto error;
@@ -1674,7 +1716,7 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 	if (ret)
 		goto error_free;
 
-	for (i = 0; i < SRP_RQ_SIZE; i++) {
+	for (i = 0; i < target->queue_size; i++) {
 		struct srp_iu *iu = target->rx_ring[i];
 		ret = srp_post_recv(target, iu);
 		if (ret)
@@ -1933,7 +1975,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	if (target->tsk_mgmt_status)
 		return FAILED;
 
-	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+	for (i = 0; i < target->req_ring_size; ++i) {
 		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd && req->scmnd->device == scmnd->device)
 			srp_finish_req(target, req, DID_RESET << 16);
@@ -2136,9 +2178,9 @@ static struct scsi_host_template srp_template = {
 	.eh_host_reset_handler		= srp_reset_host,
 	.skip_settle_delay		= true,
 	.sg_tablesize			= SRP_DEF_SG_TABLESIZE,
-	.can_queue			= SRP_CMD_SQ_SIZE,
+	.can_queue			= SRP_DEFAULT_CMD_SQ_SIZE,
 	.this_id			= -1,
-	.cmd_per_lun			= SRP_CMD_SQ_SIZE,
+	.cmd_per_lun			= SRP_DEFAULT_CMD_SQ_SIZE,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.shost_attrs			= srp_host_attrs
 };
@@ -2245,6 +2287,7 @@ enum {
 	SRP_OPT_SG_TABLESIZE	= 1 << 11,
 	SRP_OPT_COMP_VECTOR	= 1 << 12,
 	SRP_OPT_TL_RETRY_COUNT	= 1 << 13,
+	SRP_OPT_QUEUE_SIZE	= 1 << 14,
 	SRP_OPT_ALL		= (SRP_OPT_ID_EXT	|
 				   SRP_OPT_IOC_GUID	|
 				   SRP_OPT_DGID		|
@@ -2267,6 +2310,7 @@ static const match_table_t srp_opt_tokens = {
 	{ SRP_OPT_SG_TABLESIZE,		"sg_tablesize=%u"	},
 	{ SRP_OPT_COMP_VECTOR,		"comp_vector=%u"	},
 	{ SRP_OPT_TL_RETRY_COUNT,	"tl_retry_count=%u"	},
+	{ SRP_OPT_QUEUE_SIZE,		"queue_size=%d"		},
 	{ SRP_OPT_ERR,			NULL 			}
 };
 
@@ -2361,13 +2405,25 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 			target->scsi_host->max_sectors = token;
 			break;
 
+		case SRP_OPT_QUEUE_SIZE:
+			if (match_int(args, &token) || token < 1) {
+				pr_warn("bad queue_size parameter '%s'\n", p);
+				goto out;
+			}
+			target->scsi_host->can_queue = token;
+			target->queue_size = token + SRP_RSP_SQ_SIZE +
+					     SRP_TSK_MGMT_SQ_SIZE;
+			if (!(opt_mask & SRP_OPT_MAX_CMD_PER_LUN))
+				target->scsi_host->cmd_per_lun = token;
+			break;
+
 		case SRP_OPT_MAX_CMD_PER_LUN:
-			if (match_int(args, &token)) {
+			if (match_int(args, &token) || token < 1) {
 				pr_warn("bad max cmd_per_lun parameter '%s'\n",
 					p);
 				goto out;
 			}
-			target->scsi_host->cmd_per_lun = min(token, SRP_CMD_SQ_SIZE);
+			target->scsi_host->cmd_per_lun = token;
 			break;
 
 		case SRP_OPT_IO_CLASS:
@@ -2455,6 +2511,12 @@ static int srp_parse_options(const char *buf, struct srp_target_port *target)
 				pr_warn("target creation request is missing parameter '%s'\n",
 					srp_opt_tokens[i].pattern);
 
+	if (target->scsi_host->cmd_per_lun > target->scsi_host->can_queue
+	    && (opt_mask & SRP_OPT_MAX_CMD_PER_LUN))
+		pr_warn("cmd_per_lun = %d > queue_size = %d\n",
+			target->scsi_host->cmd_per_lun,
+			target->scsi_host->can_queue);
+
 out:
 	kfree(options);
 	return ret;
@@ -2493,11 +2555,14 @@ static ssize_t srp_create_target(struct device *dev,
 	target->sg_tablesize	= indirect_sg_entries ? : cmd_sg_entries;
 	target->allow_ext_sg	= allow_ext_sg;
 	target->tl_retry_count	= 7;
+	target->queue_size	= SRP_DEFAULT_QUEUE_SIZE;
 
 	ret = srp_parse_options(buf, target);
 	if (ret)
 		goto err;
 
+	target->req_ring_size = target->queue_size - SRP_TSK_MGMT_SQ_SIZE;
+
 	if (!srp_conn_unique(target->srp_host, target)) {
 		shost_printk(KERN_INFO, target->scsi_host,
 			     PFX "Already connected to target port with id_ext=%016llx;ioc_guid=%016llx;initiator_ext=%016llx\n",
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 446b045..5756810 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -57,14 +57,11 @@ enum {
 	SRP_MAX_LUN		= 512,
 	SRP_DEF_SG_TABLESIZE	= 12,
 
-	SRP_RQ_SHIFT    	= 6,
-	SRP_RQ_SIZE		= 1 << SRP_RQ_SHIFT,
-
-	SRP_SQ_SIZE		= SRP_RQ_SIZE,
+	SRP_DEFAULT_QUEUE_SIZE	= 1 << 6,
 	SRP_RSP_SQ_SIZE		= 1,
-	SRP_REQ_SQ_SIZE		= SRP_SQ_SIZE - SRP_RSP_SQ_SIZE,
 	SRP_TSK_MGMT_SQ_SIZE	= 1,
-	SRP_CMD_SQ_SIZE		= SRP_REQ_SQ_SIZE - SRP_TSK_MGMT_SQ_SIZE,
+	SRP_DEFAULT_CMD_SQ_SIZE = SRP_DEFAULT_QUEUE_SIZE - SRP_RSP_SQ_SIZE -
+				  SRP_TSK_MGMT_SQ_SIZE,
 
 	SRP_TAG_NO_REQ		= ~0U,
 	SRP_TAG_TSK_MGMT	= 1U << 31,
@@ -156,6 +153,8 @@ struct srp_target_port {
 	char			target_name[32];
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
+	int			queue_size;
+	int			req_ring_size;
 	int			comp_vector;
 	int			tl_retry_count;
 
@@ -173,9 +172,9 @@ struct srp_target_port {
 
 	int			zero_req_lim;
 
-	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
-	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
-	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
+	struct srp_iu	       **tx_ring;
+	struct srp_iu	       **rx_ring;
+	struct srp_request	*req_ring;
 
 	struct work_struct	tl_err_work;
 	struct work_struct	remove_work;
-- 
1.8.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
