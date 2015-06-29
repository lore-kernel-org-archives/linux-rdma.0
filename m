From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH V2 5/5] RDMA/isert: support iWARP devices
Date: Mon, 29 Jun 2015 16:36:29 -0500
Message-ID: <20150629213629.4188.97608.stgit@build.ogc.int>
References: <20150629213332.4188.87551.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150629213332.4188.87551.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use rdma_get_dma_mr() to allocate the DMA MR.

Use rdma_fast_reg_access_flags() to set the access_flags for fast
register work requests.

Use the device's max_sge_rd capability to compute the target's read sge
depth.  Save both the read and write max_sge values in the isert_conn
struct, and use these when creating RDMA_READ work requests.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   33 +++++++++++++++++++++----------
 drivers/infiniband/ulp/isert/ib_isert.h |    3 ++-
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9e7b492..7f0b364 100644
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
@@ -352,6 +354,7 @@ static int
 isert_create_device_ib_res(struct isert_device *device)
 {
 	struct ib_device_attr *dev_attr;
+	int mr_roles;
 	int ret;
 
 	dev_attr = &device->dev_attr;
@@ -383,7 +386,9 @@ isert_create_device_ib_res(struct isert_device *device)
 		goto out_cq;
 	}
 
-	device->mr = ib_get_dma_mr(device->pd, IB_ACCESS_LOCAL_WRITE);
+	mr_roles = RDMA_MRR_RECV | RDMA_MRR_SEND | RDMA_MRR_WRITE_SOURCE |
+		   RDMA_MRR_READ_DEST;
+	device->mr = rdma_get_dma_mr(device->pd, mr_roles, 0);
 	if (IS_ERR(device->mr)) {
 		ret = PTR_ERR(device->mr);
 		isert_err("failed to create dma mr, device %p, ret=%d\n",
@@ -2375,7 +2380,7 @@ isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 static int
 isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 		    struct ib_sge *ib_sge, struct ib_send_wr *send_wr,
-		    u32 data_left, u32 offset)
+		    u32 data_left, u32 offset, u32 max_sge)
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct scatterlist *sg_start, *tmp_sg;
@@ -2386,7 +2391,7 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 
 	sg_off = offset / PAGE_SIZE;
 	sg_start = &cmd->se_cmd.t_data_sg[sg_off];
-	sg_nents = min(cmd->se_cmd.t_data_nents - sg_off, isert_conn->max_sge);
+	sg_nents = min(cmd->se_cmd.t_data_nents - sg_off, max_sge);
 	page_off = offset % PAGE_SIZE;
 
 	send_wr->sg_list = ib_sge;
@@ -2430,8 +2435,9 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	struct isert_data_buf *data = &wr->data;
 	struct ib_send_wr *send_wr;
 	struct ib_sge *ib_sge;
-	u32 offset, data_len, data_left, rdma_write_max, va_offset = 0;
+	u32 offset, data_len, data_left, rdma_max_len, va_offset = 0;
 	int ret = 0, i, ib_sge_cnt;
+	u32 max_sge;
 
 	isert_cmd->tx_desc.isert_cmd = isert_cmd;
 
@@ -2453,7 +2459,12 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
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
@@ -2463,11 +2474,11 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
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
@@ -2489,7 +2500,7 @@ isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		}
 
 		ib_sge_cnt = isert_build_rdma_wr(isert_conn, isert_cmd, ib_sge,
-					send_wr, data_len, offset);
+					send_wr, data_len, offset, max_sge);
 		ib_sge += ib_sge_cnt;
 
 		offset += data_len;
@@ -2616,8 +2627,8 @@ isert_fast_reg_mr(struct isert_conn *isert_conn,
 	fr_wr.wr.fast_reg.page_shift = PAGE_SHIFT;
 	fr_wr.wr.fast_reg.length = mem->len;
 	fr_wr.wr.fast_reg.rkey = mr->rkey;
-	fr_wr.wr.fast_reg.access_flags = IB_ACCESS_LOCAL_WRITE;
-
+	fr_wr.wr.fast_reg.access_flags = rdma_fast_reg_access_flags(
+		device->pd, RDMA_MRR_WRITE_SOURCE | RDMA_MRR_READ_DEST, 0);
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
