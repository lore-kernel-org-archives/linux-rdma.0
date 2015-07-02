From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V4 5/5] RDMA/isert: Limit read depth based on the device
 max_sge_rd capability
Date: Thu, 02 Jul 2015 10:16:30 -0500
Message-ID: <20150702151629.12946.7797.stgit@build.ogc.int>
References: <20150702151508.12946.29133.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150702151508.12946.29133.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use the device's max_sge_rd capability to compute the target's read sge
depth.  Save both the read and write max_sge values in the isert_conn
struct, and use these when creating RDMA_WRITE/READ work requests.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   31 +++++++++++++++++++++++--------
 drivers/infiniband/ulp/isert/ib_isert.h |    3 ++-
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 2737ade..c2c7037 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -163,7 +163,9 @@ isert_create_qp(struct isert_conn *isert_conn,
 	 * outgoing control PDU responses.
 	 */
 	attr.cap.max_send_sge = max(2, device->dev_attr.max_sge - 2);
-	isert_conn->max_sge = attr.cap.max_send_sge;
+	isert_conn->max_write_sge = attr.cap.max_send_sge;
+	isert_conn->max_read_sge = min_t(u32, device->dev_attr.max_sge_rd,
+					 attr.cap.max_send_sge);
 
 	attr.cap.max_recv_sge = 1;
 	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
@@ -2376,7 +2378,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 static int
 isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 		    struct ib_sge *ib_sge, struct ib_send_wr *send_wr,
-		    u32 data_left, u32 offset)
+		    u32 data_left, u32 offset, u32 max_sge)
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct scatterlist *sg_start, *tmp_sg;
@@ -2387,7 +2389,7 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 
 	sg_off = offset / PAGE_SIZE;
 	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
-	sg_nents = min(cmd->se_cmd.t_data_nents - sg_off, isert_conn->max_sge);
+	sg_nents = min(cmd->se_cmd.t_data_nents - sg_off, max_sge);
 	page_off = offset % PAGE_SIZE;
 
 	send_wr->sg_list = ib_sge;
@@ -2431,8 +2433,9 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct isert_data_buf *data = &wr->data;
 	struct ib_send_wr *send_wr;
 	struct ib_sge *ib_sge;
-	u32 offset, data_len, data_left, rdma_write_max, va_offset = 0;
+	u32 offset, data_len, data_left, rdma_max_len, va_offset = 0;
 	int ret = 0, i, ib_sge_cnt;
+	u32 max_sge;
 
 	isert_cmd->tx_desc.isert_cmd = isert_cmd;
 
@@ -2454,7 +2457,12 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	}
 	wr->ib_sge = ib_sge;
 
-	wr->send_wr_num = DIV_ROUND_UP(data->nents, isert_conn->max_sge);
+	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE)
+		max_sge = isert_conn->max_write_sge;
+	else
+		max_sge =  isert_conn->max_read_sge;
+
+	wr->send_wr_num = DIV_ROUND_UP(data->nents, max_sge);
 	wr->send_wr = kzalloc(sizeof(struct ib_send_wr) * wr->send_wr_num,
 				GFP_KERNEL);
 	if (!wr->send_wr) {
@@ -2464,11 +2472,11 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	}
 
 	wr->isert_cmd = isert_cmd;
-	rdma_write_max = isert_conn->max_sge * PAGE_SIZE;
+	rdma_max_len = max_sge * PAGE_SIZE;
 
 	for (i = 0; i < wr->send_wr_num; i++) {
 		send_wr = &isert_cmd->rdma_wr.send_wr[i];
-		data_len = min(data_left, rdma_write_max);
+		data_len = min(data_left, rdma_max_len);
 
 		send_wr->send_flags = 0;
 		if (wr->iser_ib_op == ISER_IB_RDMA_WRITE) {
@@ -2490,7 +2498,7 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		}
 
 		ib_sge_cnt = isert_build_rdma_wr(isert_conn, isert_cmd, ib_sge,
-					send_wr, data_len, offset);
+					send_wr, data_len, offset, max_sge);
 		ib_sge += ib_sge_cnt;
 
 		offset += data_len;
@@ -2619,6 +2627,13 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	fr_wr.wr.fast_reg.rkey = mr->rkey;
 	fr_wr.wr.fast_reg.access_flags = IB_ACCESS_LOCAL_WRITE;
 
+	/*
+	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
+	 * an RDMA_READ.
+	 */
+	if (rdma_protocol_iwarp(ib_dev, isert_conn->cm_id->port_num))
+		fr_wr.wr.fast_reg.access_flags |= IB_ACCESS_REMOTE_WRITE;
+
 	if (!wr)
 		wr = &fr_wr;
 	else
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 9ec23a7..29fde27 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -152,7 +152,8 @@ struct isert_conn {
 	u32			responder_resources;
 	u32			initiator_depth;
 	bool			pi_support;
-	u32			max_sge;
+	u32			max_write_sge;
+	u32			max_read_sge;
 	char			*login_buf;
 	char			*login_req_buf;
 	char			*login_rsp_buf;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
