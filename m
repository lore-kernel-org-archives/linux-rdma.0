From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 11/12] iser-target: Kill the ->isert_cmd back pointer in struct iser_tx_desc
Date: Wed, 24 Feb 2016 19:24:08 +0200
Message-ID: <1456334649-21437-12-git-send-email-sagig@mellanox.com>
References: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456334649-21437-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

We only use the pointer when processing regular iSER commands, and it then
always points to the struct iser_cmd that contains the TX descriptor.

Remove it and rely on container_of to save a little space and avoid a
pointer that is updated multiple times per processed command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 11 +++--------
 drivers/infiniband/ulp/isert/ib_isert.h |  6 +++++-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index dbaf784ae190..57e4edd661c5 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1041,7 +1041,6 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 	tx_desc->iser_header.flags = ISCSI_CTRL;
 
 	tx_desc->num_sge = 1;
-	tx_desc->isert_cmd = isert_cmd;
 
 	if (tx_desc->tx_sg[0].lkey != device->pd->local_dma_lkey) {
 		tx_desc->tx_sg[0].lkey = device->pd->local_dma_lkey;
@@ -1882,7 +1881,7 @@ isert_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_conn *isert_conn = wc->qp->qp_context;
 	struct isert_device *device = isert_conn->device;
 	struct iser_tx_desc *desc = cqe_to_tx_desc(wc->wr_cqe);
-	struct isert_cmd *isert_cmd = desc->isert_cmd;
+	struct isert_cmd *isert_cmd = tx_desc_to_cmd(desc);
 	struct se_cmd *cmd = &isert_cmd->iscsi_cmd->se_cmd;
 	int ret = 0;
 
@@ -1916,7 +1915,7 @@ isert_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_conn *isert_conn = wc->qp->qp_context;
 	struct isert_device *device = isert_conn->device;
 	struct iser_tx_desc *desc = cqe_to_tx_desc(wc->wr_cqe);
-	struct isert_cmd *isert_cmd = desc->isert_cmd;
+	struct isert_cmd *isert_cmd = tx_desc_to_cmd(desc);
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	int ret = 0;
@@ -2009,7 +2008,7 @@ isert_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct isert_conn *isert_conn = wc->qp->qp_context;
 	struct ib_device *ib_dev = isert_conn->cm_id->device;
 	struct iser_tx_desc *tx_desc = cqe_to_tx_desc(wc->wr_cqe);
-	struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
+	struct isert_cmd *isert_cmd = tx_desc_to_cmd(tx_desc);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		isert_print_wc(wc, "send");
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
index f552797dc863..192788a4820c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -110,7 +110,6 @@ struct iser_tx_desc {
 	struct ib_sge	tx_sg[2];
 	struct ib_cqe	tx_cqe;
 	int		num_sge;
-	struct isert_cmd *isert_cmd;
 	struct ib_send_wr send_wr;
 } __packed;
 
@@ -181,6 +180,11 @@ struct isert_cmd {
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
1.8.4.3
