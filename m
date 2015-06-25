From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Thu, 25 Jun 2015 10:39:23 -0500
Message-ID: <20150625153922.13272.41789.stgit@build.ogc.int>
References: <20150625153754.13272.432.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150625153754.13272.432.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, orgerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Memory regions that are the target of an iWARP RDMA READ RESPONSE need
REMOTE_WRITE access rights.  So enable REMOTE_WRITE for iWARP devices.

iWARP RDMA READ target sge depth is 1.  So save the max_read_sge in
the target device structure and use that when creating RDMA_READ work
requests.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Tested-by: Vasu Dev <vasu.dev-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   55 ++++++++++++++++++++++++++-----
 drivers/infiniband/ulp/isert/ib_isert.h |    1 +
 2 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9e7b492..b5cde5d 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -165,6 +165,11 @@ isert_create_qp(struct isert_conn *isert_conn,
 	attr.cap.max_send_sge = max(2, device->dev_attr.max_sge - 2);
 	isert_conn->max_sge = attr.cap.max_send_sge;
 
+	if (rdma_cap_read_multi_sge(device->ib_device, cma_id->port_num))
+		isert_conn->max_read_sge = isert_conn->max_sge;
+	else
+		isert_conn->max_read_sge = 1;
+
 	attr.cap.max_recv_sge = 1;
 	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	attr.qp_type = IB_QPT_RC;
@@ -348,6 +353,17 @@ out_cq:
 	return ret;
 }
 
+static int any_port_is_iwarp(struct isert_device *device)
+{
+	int i;
+
+	for (i = rdma_start_port(device->ib_device);
+	     i <= rdma_end_port(device->ib_device); i++)
+		if (rdma_protocol_iwarp(device->ib_device, i))
+			return 1;
+	return 0;
+}
+
 static int
 isert_create_device_ib_res(struct isert_device *device)
 {
@@ -383,7 +399,17 @@ isert_create_device_ib_res(struct isert_device *device)
 		goto out_cq;
 	}
 
-	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
+	/*
+	 * IWARP transports need REMOTE_WRITE for MRs used as the target of
+	 * an RDMA_READ.  Since the DMA MR is used for all ports, then if
+	 * any port is running IWARP, add REMOTE_WRITE.
+	 */
+	if (any_port_is_iwarp(device))
+		device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE |
+						       IB_ACCESS_REMOTE_WRITE);
+	else
+		device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
+
 	if (IS_ERR(device->mr)) {
 		ret = PTR_ERR(device->mr);
 		isert_err("failed to create dma mr, device %p, ret=%d\n",
@@ -2375,7 +2401,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 static int
 isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 		    struct ib_sge *ib_sge, struct ib_send_wr *send_wr,
-		    u32 data_left, u32 offset)
+		    u32 data_left, u32 offset, u32 max_sge)
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct scatterlist *sg_start, *tmp_sg;
@@ -2386,7 +2412,7 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 
 	sg_off = offset / PAGE_SIZE;
 	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
-	sg_nents = min(cmd->se_cmd.t_data_nents - sg_off, isert_conn->max_sge);
+	sg_nents = min(cmd->se_cmd.t_data_nents - sg_off, max_sge);
 	page_off = offset % PAGE_SIZE;
 
 	send_wr->sg_list = ib_sge;
@@ -2430,8 +2456,9 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct isert_data_buf *data = &wr->data;
 	struct ib_send_wr *send_wr;
 	struct ib_sge *ib_sge;
-	u32 offset, data_len, data_left, rdma_write_max, va_offset = 0;
+	u32 offset, data_len, data_left, rdma_max_len, va_offset = 0;
 	int ret = 0, i, ib_sge_cnt;
+	u32 max_sge;
 
 	isert_cmd->tx_desc.isert_cmd = isert_cmd;
 
@@ -2453,7 +2480,12 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	}
 	wr->ib_sge = ib_sge;
 
-	wr->send_wr_num = DIV_ROUND_UP(data->nents, isert_conn->max_sge);
+	if (wr->iser_ib_op == ISER_IB_RDMA_WRITE)
+		max_sge = isert_conn->max_sge;
+	else
+		max_sge =  isert_conn->max_read_sge;
+
+	wr->send_wr_num = DIV_ROUND_UP(data->nents, max_sge);
 	wr->send_wr = kzalloc(sizeof(struct ib_send_wr) * wr->send_wr_num,
 				GFP_KERNEL);
 	if (!wr->send_wr) {
@@ -2463,11 +2495,11 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
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
@@ -2489,7 +2521,7 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		}
 
 		ib_sge_cnt = isert_build_rdma_wr(isert_conn, isert_cmd, ib_sge,
-					send_wr, data_len, offset);
+					send_wr, data_len, offset, max_sge);
 		ib_sge += ib_sge_cnt;
 
 		offset += data_len;
@@ -2618,6 +2650,13 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
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
index 9ec23a7..47cf11b 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -153,6 +153,7 @@ struct isert_conn {
 	u32			initiator_depth;
 	bool			pi_support;
 	u32			max_sge;
+	u32			max_read_sge;
 	char			*login_buf;
 	char			*login_req_buf;
 	char			*login_rsp_buf;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
