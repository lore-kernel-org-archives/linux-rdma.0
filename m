From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 5/5] IB/isert: Kill the ->isert_cmd back pointer in struct iser_tx_desc
Date: Mon, 22 Feb 2016 14:49:18 +0100
Message-ID: <1456148958-27973-6-git-send-email-hch@lst.de>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456148958-27973-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We only use the pointer when processing regular iSER commands, and it then
always points to the struct iser_cmd that contains the TX descriptor.

Remove it and rely on container_of to save a little space and avoid a
pointer that is updated multiple times per processed command.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 11 +++--------
 drivers/infiniband/ulp/isert/ib_isert.h |  6 +++++-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 02fb3e6..5e95ddd 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1040,7 +1040,6 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 	tx_desc->iser_header.flags = ISCSI_CTRL;
 
 	tx_desc->num_sge = 1;
-	tx_desc->isert_cmd = isert_cmd;
 
 	if (tx_desc->tx_sg[0].lkey != device->pd->local_dma_lkey) {
 		tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
@@ -1891,7 +1890,7 @@ isert_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_conn *isert_conn = wc->qp->qp_context;
 	struct isert_device *device = isert_conn->device;
 	struct iser_tx_desc *desc = cqe_to_tx_desc(wc->wr_cqe);
-	struct isert_cmd *isert_cmd = desc->isert_cmd;
+	struct isert_cmd *isert_cmd = tx_desc_to_cmd(desc);
 	struct se_cmd *cmd = &isert_cmd->iscsi_cmd->se_cmd;
 	int ret = 0;
 
@@ -1923,7 +1922,7 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_conn *isert_conn = wc->qp->qp_context;
 	struct isert_device *device = isert_conn->device;
 	struct iser_tx_desc *desc = cqe_to_tx_desc(wc->wr_cqe);
-	struct isert_cmd *isert_cmd = desc->isert_cmd;
+	struct isert_cmd *isert_cmd = tx_desc_to_cmd(desc);
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	int ret = 0;
@@ -2011,7 +2010,7 @@ isert_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_conn *isert_conn = wc->qp->qp_context;
 	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct iser_tx_desc *tx_desc = cqe_to_tx_desc(wc->wr_cqe);
-	struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
+	struct isert_cmd *isert_cmd = tx_desc_to_cmd(tx_desc);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		isert_print_wc(wc);
@@ -2339,8 +2338,6 @@ isert_map_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn)
 	u32 offset, data_len, data_left, rdma_write_max, va_offset = 0;
 	int ret = 0, i, ib_sge_cnt;
 
-	isert_cmd->tx_desc.isert_cmd = isert_cmd;
-
 	offset = isert_cmd->iser_ib_op == ISER_IB_RDMA_READ ?
 			cmd->write_data_done : 0;
 	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
@@ -2702,8 +2699,6 @@ isert_reg_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn)
 	int ret = 0;
 	unsigned long flags;
 
-	isert_cmd->tx_desc.isert_cmd = isert_cmd;
-
 	offset = isert_cmd->iser_ib_op == ISER_IB_RDMA_READ ?
 			cmd->write_data_done : 0;
 	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 6103e68..e04f1804 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -109,7 +109,6 @@ struct iser_tx_desc {
 	struct ib_sge	tx_sg[2];
 	struct ib_cqe	tx_cqe;
 	int		num_sge;
-	struct isert_cmd *isert_cmd;
 	struct ib_send_wr send_wr;
 } __packed;
 
@@ -180,6 +179,11 @@ struct isert_cmd {
 	struct scatterlist	sg;
 };
 
+static inline struct isert_cmd *tx_desc_to_cmd(struct iser_tx_desc *desc)
+{
+	return container_of(desc, struct isert_cmd, tx_desc);
+}
+
 struct isert_device;
 
 struct isert_conn {
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
