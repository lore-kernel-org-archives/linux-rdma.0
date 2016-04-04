From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] ib_srpt: Add missing ioctx->buf + ->dma alloc_session_cb init
Date: Mon,  4 Apr 2016 18:23:53 +0000
Message-ID: <1459794233-19187-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses the v4.6-rc1 breakage for ib_srpt, and
adds the missing srpt_alloc_session_cb() to setup existing
srpt_ioctx buf + dma resources for srpt_send_ioctx->ioctx.

Also, add a srpt_free_sess_cmd_map_res() to do the clean
during shutdown in srpt_release_channel_work(), and drop
the now left-over ch->ioctx_ring[].

Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 79 +++++++++++++++++++++++++++--------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 -
 2 files changed, 61 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0bd3cb2..c4e0a0a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1266,7 +1266,9 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 {
 	struct se_session *se_sess;
 	struct srpt_send_ioctx *ioctx;
-	int tag;
+	void *buf;
+	dma_addr_t dma;
+	int tag, index;
 
 	BUG_ON(!ch);
 	se_sess = ch->sess;
@@ -1277,12 +1279,19 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 		return NULL;
 	}
 	ioctx = &((struct srpt_send_ioctx *)se_sess->sess_cmd_map)[tag];
+	buf = ioctx->ioctx.buf;
+	dma = ioctx->ioctx.dma;
+	index = ioctx->ioctx.index;
+
 	memset(ioctx, 0, sizeof(struct srpt_send_ioctx));
 	ioctx->ch = ch;
 	spin_lock_init(&ioctx->spinlock);
 	ioctx->state = SRPT_STATE_NEW;
 	init_completion(&ioctx->tx_done);
 
+	ioctx->ioctx.buf = buf;
+	ioctx->ioctx.dma = dma;
+	ioctx->ioctx.index = index;
 	ioctx->cmd.map_tag = tag;
 
 	return ioctx;
@@ -1961,6 +1970,24 @@ static void srpt_free_ch(struct kref *kref)
 	kfree(ch);
 }
 
+static void srpt_free_sess_cmd_map_res(struct se_session *se_sess)
+{
+	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
+	struct srpt_device *sdev = ch->sport->sdev;
+	struct srpt_send_ioctx *ioctx;
+	u32 i, dma_size = ch->rsp_size;
+
+	for (i = 0; i < ch->rq_size; i++) {
+		ioctx = &((struct srpt_send_ioctx *)se_sess->sess_cmd_map)[i];
+
+		if (!ib_dma_mapping_error(sdev->device, ioctx->ioctx.dma))
+			ib_dma_unmap_single(sdev->device, ioctx->ioctx.dma,
+					    dma_size, DMA_TO_DEVICE);
+		if (ioctx->ioctx.buf)
+			kfree(ioctx->ioctx.buf);
+	}
+}
+
 static void srpt_release_channel_work(struct work_struct *w)
 {
 	struct srpt_rdma_ch *ch;
@@ -1981,6 +2008,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	target_wait_for_sess_cmds(se_sess);
 
 	transport_deregister_session_configfs(se_sess);
+	srpt_free_sess_cmd_map_res(se_sess);
 	transport_deregister_session(se_sess);
 	ch->sess = NULL;
 
@@ -1988,10 +2016,6 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	srpt_destroy_ch_ib(ch);
 
-	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
-			     ch->sport->sdev, ch->rq_size,
-			     ch->rsp_size, DMA_TO_DEVICE);
-
 	mutex_lock(&sdev->mutex);
 	list_del_init(&ch->list);
 	if (ch->release_done)
@@ -2003,6 +2027,35 @@ static void srpt_release_channel_work(struct work_struct *w)
 	kref_put(&ch->kref, srpt_free_ch);
 }
 
+static int srpt_alloc_session_cb(struct se_portal_group *se_tpg,
+				 struct se_session *se_sess, void *p)
+{
+	struct srpt_rdma_ch *ch = p;
+	struct srpt_device *sdev = ch->sport->sdev;
+	struct srpt_send_ioctx *ioctx;
+	u32 i, dma_size = ch->rsp_size;
+
+	for (i = 0; i < ch->rq_size; i++) {
+		ioctx = &((struct srpt_send_ioctx *)se_sess->sess_cmd_map)[i];
+		ioctx->ioctx.index = i;
+
+		ioctx->ioctx.buf = kmalloc(dma_size, GFP_KERNEL);
+		if (!ioctx->ioctx.buf)
+			goto err_free_res;
+
+		ioctx->ioctx.dma = ib_dma_map_single(sdev->device, ioctx->ioctx.buf,
+						     dma_size, DMA_TO_DEVICE);
+		if (ib_dma_mapping_error(sdev->device, ioctx->ioctx.dma))
+			goto err_free_res;
+	}
+
+	return 0;
+
+err_free_res:
+	srpt_free_sess_cmd_map_res(se_sess);
+	return -ENOMEM;
+}
+
 /**
  * srpt_cm_req_recv() - Process the event IB_CM_REQ_RECEIVED.
  *
@@ -2136,20 +2189,13 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
 	ch->rsp_size = ch->sport->port_attrib.srp_max_rsp_size;
 
-	ch->ioctx_ring = (struct srpt_send_ioctx **)
-		srpt_alloc_ioctx_ring(ch->sport->sdev, ch->rq_size,
-				      sizeof(*ch->ioctx_ring[0]),
-				      ch->rsp_size, DMA_TO_DEVICE);
-	if (!ch->ioctx_ring)
-		goto free_ch;
-
 	ret = srpt_create_ch_ib(ch);
 	if (ret) {
 		rej->reason = cpu_to_be32(
 			      SRP_LOGIN_REJ_INSUFFICIENT_RESOURCES);
 		pr_err("rejected SRP_LOGIN_REQ because creating"
 		       " a new RDMA channel failed.\n");
-		goto free_ring;
+		goto free_ch;
 	}
 
 	ret = srpt_ch_qp_rtr(ch, ch->qp);
@@ -2175,7 +2221,8 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 try_again:
 	ch->sess = target_alloc_session(&sport->port_tpg_1, ch->rq_size,
 					sizeof(struct srpt_send_ioctx),
-					TARGET_PROT_NORMAL, p, ch, NULL);
+					TARGET_PROT_NORMAL, p, ch,
+					srpt_alloc_session_cb);
 	if (IS_ERR(ch->sess)) {
 		pr_info("Rejected login because no ACL has been"
 			" configured yet for initiator %s.\n", p);
@@ -2240,10 +2287,6 @@ release_channel:
 destroy_ib:
 	srpt_destroy_ch_ib(ch);
 
-free_ring:
-	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
-			     ch->sport->sdev, ch->rq_size,
-			     ch->rsp_size, DMA_TO_DEVICE);
 free_ch:
 	kfree(ch);
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index ca288f0..a0e3403 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -251,7 +251,6 @@ enum rdma_ch_state {
  * @spinlock:      Protects free_list and state.
  * @free_list:     Head of list with free send I/O contexts.
  * @state:         channel state. See also enum rdma_ch_state.
- * @ioctx_ring:    Send ring.
  * @list:          Node for insertion in the srpt_device.rch_list list.
  * @cmd_wait_list: List of SCSI commands that arrived before the RTU event. This
  *                 list contains struct srpt_ioctx elements and is protected
@@ -279,7 +278,6 @@ struct srpt_rdma_ch {
 	spinlock_t		spinlock;
 	struct list_head	free_list;
 	enum rdma_ch_state	state;
-	struct srpt_send_ioctx	**ioctx_ring;
 	struct list_head	list;
 	struct list_head	cmd_wait_list;
 	struct se_session	*sess;
-- 
1.9.1
