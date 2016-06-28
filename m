From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 4/5] IB/srpt: Limit the number of SG elements per work request
Date: Tue, 28 Jun 2016 13:28:54 +0200
Message-ID: <f28d55ea-e193-150e-a3bf-7bff7db72bdd@sandisk.com>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <419391ba-0c39-11ce-f249-84b428dc73d5-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Limit the number of SG elements per work request to what the HCA
and the queue pair support.

Fixes: 34693573fde0 ("IB/srpt: Reduce QP buffer size")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 17 +++++++++++------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  6 +++++-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 2ed65f5..6314d10 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -803,7 +803,6 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 {
 	enum dma_data_direction dir = target_reverse_dma_direction(&ioctx->cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
-	struct ib_device *dev = ch->qp->pd->device;
 	struct scatterlist *prev = NULL;
 	u32 max_sge;
 	unsigned prev_nents;
@@ -818,8 +817,7 @@ static int srpt_alloc_rw_ctxs(struct srpt_send_ioctx *ioctx,
 			return -ENOMEM;
 	}
 
-	max_sge = dir == DMA_TO_DEVICE ? dev->attrs.max_sge :
-		dev->attrs.max_sge_rd;
+	max_sge = dir == DMA_TO_DEVICE ? ch->max_send_sge : ch->max_recv_sge;
 
 	for (i = ioctx->n_rw_ctx; i < nbufs; i++, db++) {
 		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
@@ -1607,6 +1605,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	struct ib_qp_init_attr *qp_init;
 	struct srpt_port *sport = ch->sport;
 	struct srpt_device *sdev = sport->sdev;
+	const struct ib_device_attr *attrs = &sdev->device->attrs;
 	u32 srp_sq_size = sport->port_attrib.srp_sq_size;
 	int ret;
 
@@ -1644,7 +1643,7 @@ retry:
 	 */
 	qp_init->cap.max_send_wr = srp_sq_size / 2;
 	qp_init->cap.max_rdma_ctxs = srp_sq_size / 2;
-	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
+	qp_init->cap.max_send_sge = min(attrs->max_sge, SRPT_MAX_SG_PER_WQE);
 	qp_init->port_num = ch->sport->port;
 
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
@@ -1663,8 +1662,14 @@ retry:
 
 	atomic_set(&ch->sq_wr_avail, qp_init->cap.max_send_wr);
 
-	pr_debug("%s: max_cqe= %d max_sge= %d sq_size = %d cm_id= %p\n",
-		 __func__, ch->cq->cqe, qp_init->cap.max_send_sge,
+	/*
+	 * qp_init->cap.max_recv_sge is not relevant for SRQ so use
+	 * max_send_sge instead for SRQ.
+	 */
+	ch->max_send_sge = qp_init->cap.max_send_sge;
+	ch->max_recv_sge = qp_init->cap.max_send_sge;
+	pr_debug("%s: max_cqe= %d max_sge= %d w %d r sq_size = %d cm_id= %p\n",
+		 __func__, ch->cq->cqe, ch->max_send_sge, ch->max_recv_sge,
 		 qp_init->cap.max_send_wr, ch->cm_id);
 
 	ret = srpt_init_ch_qp(ch, ch->qp);
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 3890304..b0876d9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -106,7 +106,7 @@ enum {
 	SRP_LOGIN_RSP_MULTICHAN_MAINTAINED = 0x2,
 
 	SRPT_DEF_SG_TABLESIZE = 128,
-	SRPT_DEF_SG_PER_WQE = 16,
+	SRPT_MAX_SG_PER_WQE = 16,
 
 	MIN_SRPT_SQ_SIZE = 16,
 	DEF_SRPT_SQ_SIZE = 4096,
@@ -235,6 +235,8 @@ enum rdma_ch_state {
  * @cq:            IB completion queue for this channel.
  * @rq_size:       IB receive queue size.
  * @rsp_size	   IB response message size in bytes.
+ * @max_send_sge:  Maximum SG elements per WR for send requests posted on @qp.
+ * @max_recv_sge:  Maximum SG elements per WR for recv requests posted on @qp.
  * @sq_wr_avail:   number of work requests available in the send queue.
  * @sport:         pointer to the information of the HCA port used by this
  *                 channel.
@@ -265,6 +267,8 @@ struct srpt_rdma_ch {
 	struct kref		kref;
 	int			rq_size;
 	u32			rsp_size;
+	int			max_send_sge;
+	int			max_recv_sge;
 	atomic_t		sq_wr_avail;
 	struct srpt_port	*sport;
 	u8			i_port_id[16];
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
