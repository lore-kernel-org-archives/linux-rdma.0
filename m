From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 04/12] IB/srpt: Rename a local variable, a member variable and a constant
Date: Mon,  8 Jan 2018 11:00:43 -0800
Message-ID: <20180108190051.32008-5-bart.vanassche@wdc.com>
References: <20180108190051.32008-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108190051.32008-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Rename rsp_size into max_rsp_size and SRPT_RQ_SIZE into MAX_SRPT_RQ_SIZE.
The new names better reflect the role of this member variable and constant.
Since the prefix "srp_" is superfluous in the context of the function
that creates an RDMA channel, rename srp_sq_size into sq_size.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 26 +++++++++++++-------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  6 +++---
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 1bcf8b3b6095..4fb884c070af 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -325,7 +325,7 @@ static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
 	if (sdev->use_srq)
 		send_queue_depth = sdev->srq_size;
 	else
-		send_queue_depth = min(SRPT_RQ_SIZE,
+		send_queue_depth = min(MAX_SRPT_RQ_SIZE,
 				       sdev->device->attrs.max_qp_wr);
 
 	memset(iocp, 0, sizeof(*iocp));
@@ -1693,7 +1693,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	struct srpt_port *sport = ch->sport;
 	struct srpt_device *sdev = sport->sdev;
 	const struct ib_device_attr *attrs = &sdev->device->attrs;
-	u32 srp_sq_size = sport->port_attrib.srp_sq_size;
+	int sq_size = sport->port_attrib.srp_sq_size;
 	int i, ret;
 
 	WARN_ON(ch->rq_size < 1);
@@ -1704,12 +1704,12 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 		goto out;
 
 retry:
-	ch->cq = ib_alloc_cq(sdev->device, ch, ch->rq_size + srp_sq_size,
+	ch->cq = ib_alloc_cq(sdev->device, ch, ch->rq_size + sq_size,
 			0 /* XXX: spread CQs */, IB_POLL_WORKQUEUE);
 	if (IS_ERR(ch->cq)) {
 		ret = PTR_ERR(ch->cq);
 		pr_err("failed to create CQ cqe= %d ret= %d\n",
-		       ch->rq_size + srp_sq_size, ret);
+		       ch->rq_size + sq_size, ret);
 		goto out;
 	}
 
@@ -1727,8 +1727,8 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	 * both both, as RDMA contexts will also post completions for the
 	 * RDMA READ case.
 	 */
-	qp_init->cap.max_send_wr = min(srp_sq_size / 2, attrs->max_qp_wr + 0U);
-	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
+	qp_init->cap.max_send_wr = min(sq_size / 2, attrs->max_qp_wr);
+	qp_init->cap.max_rdma_ctxs = sq_size / 2;
 	qp_init->cap.max_send_sge = min(attrs->max_sge, SRPT_MAX_SG_PER_WQE);
 	qp_init->port_num = ch->sport->port;
 	if (sdev->use_srq) {
@@ -1742,8 +1742,8 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (IS_ERR(ch->qp)) {
 		ret = PTR_ERR(ch->qp);
 		if (ret == -ENOMEM) {
-			srp_sq_size /= 2;
-			if (srp_sq_size >= MIN_SRPT_SQ_SIZE) {
+			sq_size /= 2;
+			if (sq_size >= MIN_SRPT_SQ_SIZE) {
 				ib_destroy_cq(ch->cq);
 				goto retry;
 			}
@@ -1950,7 +1950,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
-			     ch->rsp_size, DMA_TO_DEVICE);
+			     ch->max_rsp_size, DMA_TO_DEVICE);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_recv_ring,
 			     sdev, ch->rq_size,
@@ -2098,16 +2098,16 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	 * depth to avoid that the initiator driver has to report QUEUE_FULL
 	 * to the SCSI mid-layer.
 	 */
-	ch->rq_size = min(SRPT_RQ_SIZE, sdev->device->attrs.max_qp_wr);
+	ch->rq_size = min(MAX_SRPT_RQ_SIZE, sdev->device->attrs.max_qp_wr);
 	spin_lock_init(&ch->spinlock);
 	ch->state = CH_CONNECTING;
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
-	ch->rsp_size = ch->sport->port_attrib.srp_max_rsp_size;
+	ch->max_rsp_size = ch->sport->port_attrib.srp_max_rsp_size;
 
 	ch->ioctx_ring = (struct srpt_send_ioctx **)
 		srpt_alloc_ioctx_ring(ch->sport->sdev, ch->rq_size,
 				      sizeof(*ch->ioctx_ring[0]),
-				      ch->rsp_size, DMA_TO_DEVICE);
+				      ch->max_rsp_size, DMA_TO_DEVICE);
 	if (!ch->ioctx_ring)
 		goto free_ch;
 
@@ -2235,7 +2235,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 free_ring:
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
-			     ch->rsp_size, DMA_TO_DEVICE);
+			     ch->max_rsp_size, DMA_TO_DEVICE);
 free_ch:
 	kfree(ch);
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 0c94cd6a7e9d..8f90a7ca98e6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -114,7 +114,7 @@ enum {
 
 	MIN_SRPT_SQ_SIZE = 16,
 	DEF_SRPT_SQ_SIZE = 4096,
-	SRPT_RQ_SIZE = 128,
+	MAX_SRPT_RQ_SIZE = 128,
 	MIN_SRPT_SRQ_SIZE = 4,
 	DEFAULT_SRPT_SRQ_SIZE = 4095,
 	MAX_SRPT_SRQ_SIZE = 65535,
@@ -248,7 +248,7 @@ enum rdma_ch_state {
  * @zw_cqe:	   Zero-length write CQE.
  * @kref:	   kref for this channel.
  * @rq_size:       IB receive queue size.
- * @rsp_size:	   IB response message size in bytes.
+ * @max_rsp_size:  Maximum size of an RSP response message in bytes.
  * @sq_wr_avail:   number of work requests available in the send queue.
  * @sport:         pointer to the information of the HCA port used by this
  *                 channel.
@@ -280,7 +280,7 @@ struct srpt_rdma_ch {
 	struct ib_cqe		zw_cqe;
 	struct kref		kref;
 	int			rq_size;
-	u32			rsp_size;
+	u32			max_rsp_size;
 	atomic_t		sq_wr_avail;
 	struct srpt_port	*sport;
 	u8			i_port_id[16];
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
