From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/13] IB/isert: the kill ->isert_cmd back pointer in the struct iser_tx_desc
Date: Sat, 27 Feb 2016 19:10:29 +0100
Message-ID: <1456596631-19418-12-git-send-email-hch@lst.de>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456596631-19418-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: swise@opengridcomputing.com, sagig@mellanox.com, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We only use the pointer when processing regular iSER commands, and it then
always points to the struct iser_cmd that contains the TX descriptor.

Remove it and rely on container_of to save a little space and avoid a
pointer that is updated multiple times per processed command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 14 ++++++--------
 drivers/infiniband/ulp/isert/ib_isert.h |  1 -
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index c93be93..e1a553f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1043,7 +1043,6 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 	tx_desc->iser_header.flags = ISCSI_CTRL;
 
 	tx_desc->num_sge = 1;
-	tx_desc->isert_cmd = isert_cmd;
 
 	if (tx_desc->tx_sg[0].lkey != device->pd->local_dma_lkey) {
 		tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
@@ -1896,7 +1895,8 @@ isert_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_device *device = isert_conn->device;
 	struct iser_tx_desc *desc =
 		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);
-	struct isert_cmd *isert_cmd = desc->isert_cmd;
+	struct isert_cmd *isert_cmd =
+		container_of(desc, struct isert_cmd, tx_desc);
 	struct se_cmd *cmd = &isert_cmd->iscsi_cmd->se_cmd;
 	int ret = 0;
 
@@ -1929,7 +1929,8 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_device *device = isert_conn->device;
 	struct iser_tx_desc *desc =
 		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);
-	struct isert_cmd *isert_cmd = desc->isert_cmd;
+	struct isert_cmd *isert_cmd =
+		container_of(desc, struct isert_cmd, tx_desc);
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	int ret = 0;
@@ -2019,7 +2020,8 @@ isert_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct iser_tx_desc *tx_desc =
 		container_of(wc->wr_cqe, struct iser_tx_desc, tx_cqe);
-	struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
+	struct isert_cmd *isert_cmd =
+		container_of(tx_desc, struct isert_cmd, tx_desc);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		isert_print_wc(wc);
@@ -2347,8 +2349,6 @@ isert_map_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn)
 	u32 offset, data_len, data_left, rdma_write_max, va_offset = 0;
 	int ret = 0, i, ib_sge_cnt;
 
-	isert_cmd->tx_desc.isert_cmd = isert_cmd;
-
 	offset = isert_cmd->iser_ib_op == ISER_IB_RDMA_READ ?
 			cmd->write_data_done : 0;
 	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
@@ -2710,8 +2710,6 @@ isert_reg_rdma(struct isert_cmd *isert_cmd, struct iscsi_conn *conn)
 	int ret = 0;
 	unsigned long flags;
 
-	isert_cmd->tx_desc.isert_cmd = isert_cmd;
-
 	offset = isert_cmd->iser_ib_op == ISER_IB_RDMA_READ ?
 			cmd->write_data_done : 0;
 	ret = isert_map_data_buf(isert_conn, isert_cmd, se_cmd->t_data_sg,
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index b751b6a..2614403 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -106,7 +106,6 @@ struct iser_tx_desc {
 	struct ib_sge	tx_sg[2];
 	struct ib_cqe	tx_cqe;
 	int		num_sge;
-	struct isert_cmd *isert_cmd;
 	struct ib_send_wr send_wr;
 } __packed;
 
-- 
2.1.4
