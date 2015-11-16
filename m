From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-next 08/10] iser-target: Support the remote invalidation exception
Date: Mon, 16 Nov 2015 18:37:39 +0200
Message-ID: <1447691861-3796-9-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Jenny Derzhavetz <jennyf@mellanox.com>

We'll use remote invalidate, according to negotiation result
during connection establishment. If the initiator declared that
it supports the remote invalidate exception then the target will
use IB_WR_SEND_WITH_INV with the correct rkey for the response.

Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 39 +++++++++++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h |  2 ++
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 667238f6253f..035fd12ec7ae 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -679,6 +679,25 @@ out_login_buf:
 	return ret;
 }
 
+static void
+isert_set_nego_params(struct isert_conn *isert_conn,
+		      struct rdma_conn_param *param)
+{
+	struct isert_device *device = isert_conn->device;
+
+	/* Set max inflight RDMA READ requests */
+	isert_conn->initiator_depth = min_t(u8, param->initiator_depth,
+				device->dev_attr.max_qp_init_rd_atom);
+	isert_dbg("Using initiator_depth: %u\n", isert_conn->initiator_depth);
+
+	if (param->private_data) {
+		u8 flags = *(u8 *)param->private_data;
+
+		isert_conn->snd_w_inv = !(flags & ISER_SEND_W_INV_NOT_SUP);
+		isert_info("Using remote invalidation\n");
+	}
+}
+
 static int
 isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 {
@@ -717,11 +736,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	}
 	isert_conn->device = device;
 
-	/* Set max inflight RDMA READ requests */
-	isert_conn->initiator_depth = min_t(u8,
-				event->param.conn.initiator_depth,
-				device->dev_attr.max_qp_init_rd_atom);
-	isert_dbg("Using initiator_depth: %u\n", isert_conn->initiator_depth);
+	isert_set_nego_params(isert_conn, &event->param.conn);
 
 	ret = isert_conn_setup_qp(isert_conn, cma_id);
 	if (ret)
@@ -1100,7 +1115,14 @@ isert_init_send_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 
 	isert_cmd->rdma_wr.iser_ib_op = ISER_IB_SEND;
 	send_wr->wr_id = (uintptr_t)&isert_cmd->tx_desc;
-	send_wr->opcode = IB_WR_SEND;
+
+	if (isert_conn->snd_w_inv && isert_cmd->inv_rkey) {
+		send_wr->opcode  = IB_WR_SEND_WITH_INV;
+		send_wr->ex.invalidate_rkey = isert_cmd->inv_rkey;
+	} else {
+		send_wr->opcode = IB_WR_SEND;
+	}
+
 	send_wr->sg_list = &tx_desc->tx_sg[0];
 	send_wr->num_sge = isert_cmd->tx_desc.num_sge;
 	send_wr->send_flags = IB_SEND_SIGNALED;
@@ -1489,6 +1511,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 		isert_cmd->read_va = read_va;
 		isert_cmd->write_stag = write_stag;
 		isert_cmd->write_va = write_va;
+		isert_cmd->inv_rkey = read_stag ? read_stag : write_stag;
 
 		ret = isert_handle_scsi_cmd(isert_conn, isert_cmd, cmd,
 					rx_desc, (unsigned char *)hdr);
@@ -3107,7 +3130,9 @@ isert_rdma_accept(struct isert_conn *isert_conn)
 	cp.rnr_retry_count = 7;
 
 	memset(&rsp_hdr, 0, sizeof(rsp_hdr));
-	rsp_hdr.flags = (ISERT_ZBVA_NOT_USED | ISERT_SEND_W_INV_NOT_USED);
+	rsp_hdr.flags = ISERT_ZBVA_NOT_USED;
+	if (!isert_conn->snd_w_inv)
+		rsp_hdr.flags = rsp_hdr.flags | ISERT_SEND_W_INV_NOT_USED;
 	cp.private_data = (void *)&rsp_hdr;
 	cp.private_data_len = sizeof(rsp_hdr);
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 00edd5b68ca8..b23086d3d08b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -162,6 +162,7 @@ struct isert_cmd {
 	uint32_t		write_stag;
 	uint64_t		read_va;
 	uint64_t		write_va;
+	uint32_t		inv_rkey;
 	u64			pdu_buf_dma;
 	u32			pdu_buf_len;
 	struct isert_conn	*conn;
@@ -209,6 +210,7 @@ struct isert_conn {
 	struct work_struct	release_work;
 	struct ib_recv_wr       beacon;
 	bool                    logout_posted;
+	bool                    snd_w_inv;
 };
 
 #define ISERT_MAX_CQ 64
-- 
1.8.4.3
