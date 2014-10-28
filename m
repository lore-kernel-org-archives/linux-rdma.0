From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH fixes for-3.18 6/6] IB/iser: Fix sparse warnings
Date: Tue, 28 Oct 2014 11:49:13 +0200
Message-ID: <1414489753-29199-7-git-send-email-ogerlitz@mellanox.com>
References: <1414489753-29199-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414489753-29199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arieln-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Use uintptr_t to handle wr_id casting, which was found by
Kbuild test robot and smatch. Also remove an internal definition
of variable which potentially shadows an external one (and make
sparse happy).

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |    1 -
 drivers/infiniband/ulp/iser/iser_verbs.c  |   15 ++++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 6c5ce35..5796c95 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -73,7 +73,6 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 
 	if (cmd_dir == ISER_DIR_OUT) {
 		/* copy the unaligned sg the buffer which is used for RDMA */
-		int i;
 		char *p, *from;
 
 		sgl = (struct scatterlist *)data->buf;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 5577aac..3770498 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1073,7 +1073,7 @@ int iser_post_recvl(struct iser_conn *iser_conn)
 	sge.length = ISER_RX_LOGIN_SIZE;
 	sge.lkey   = ib_conn->device->mr->lkey;
 
-	rx_wr.wr_id   = (unsigned long)iser_conn->login_resp_buf;
+	rx_wr.wr_id   = (uintptr_t)iser_conn->login_resp_buf;
 	rx_wr.sg_list = &sge;
 	rx_wr.num_sge = 1;
 	rx_wr.next    = NULL;
@@ -1097,7 +1097,7 @@ int iser_post_recvm(struct iser_conn *iser_conn, int count)
 
 	for (rx_wr = ib_conn->rx_wr, i = 0; i < count; i++, rx_wr++) {
 		rx_desc		= &iser_conn->rx_descs[my_rx_head];
-		rx_wr->wr_id	= (unsigned long)rx_desc;
+		rx_wr->wr_id	= (uintptr_t)rx_desc;
 		rx_wr->sg_list	= &rx_desc->rx_sg;
 		rx_wr->num_sge	= 1;
 		rx_wr->next	= rx_wr + 1;
@@ -1134,7 +1134,7 @@ int iser_post_send(struct ib_conn *ib_conn, struct iser_tx_desc *tx_desc,
 				      DMA_TO_DEVICE);
 
 	send_wr.next	   = NULL;
-	send_wr.wr_id	   = (unsigned long)tx_desc;
+	send_wr.wr_id	   = (uintptr_t)tx_desc;
 	send_wr.sg_list	   = tx_desc->tx_sg;
 	send_wr.num_sge	   = tx_desc->num_sge;
 	send_wr.opcode	   = IB_WR_SEND;
@@ -1184,6 +1184,7 @@ static void
 iser_handle_comp_error(struct ib_conn *ib_conn,
 		       struct ib_wc *wc)
 {
+	void *wr_id = (void *)(uintptr_t)wc->wr_id;
 	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
 						   ib_conn);
 
@@ -1192,8 +1193,8 @@ iser_handle_comp_error(struct ib_conn *ib_conn,
 			iscsi_conn_failure(iser_conn->iscsi_conn,
 					   ISCSI_ERR_CONN_FAILED);
 
-	if (is_iser_tx_desc(iser_conn, (void *)wc->wr_id)) {
-		struct iser_tx_desc *desc = (struct iser_tx_desc *)wc->wr_id;
+	if (is_iser_tx_desc(iser_conn, wr_id)) {
+		struct iser_tx_desc *desc = wr_id;
 
 		if (desc->type == ISCSI_TX_DATAOUT)
 			kmem_cache_free(ig.desc_cache, desc);
@@ -1219,12 +1220,12 @@ static void iser_handle_wc(struct ib_wc *wc)
 	ib_conn = wc->qp->qp_context;
 	if (wc->status == IB_WC_SUCCESS) {
 		if (wc->opcode == IB_WC_RECV) {
-			rx_desc = (struct iser_rx_desc *)wc->wr_id;
+			rx_desc = (struct iser_rx_desc *)(uintptr_t)wc->wr_id;
 			iser_rcv_completion(rx_desc, wc->byte_len,
 					    ib_conn);
 		} else
 		if (wc->opcode == IB_WC_SEND) {
-			tx_desc = (struct iser_tx_desc *)wc->wr_id;
+			tx_desc = (struct iser_tx_desc *)(uintptr_t)wc->wr_id;
 			iser_snd_completion(tx_desc, ib_conn);
 		} else {
 			iser_err("Unknown wc opcode %d\n", wc->opcode);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
