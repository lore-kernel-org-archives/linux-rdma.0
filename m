From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/5] IB/isert: Limit the number of SG elements per work
 request
Date: Tue, 28 Jun 2016 13:26:58 +0200
Message-ID: <885f39a6-9d75-9999-d582-e403f072bec1@sandisk.com>
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

Limit the number of SG elements per work request to what the queue
pair supports.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 10 +++++-----
 drivers/infiniband/ulp/isert/ib_isert.h |  3 ++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 06a5671..b5d6556 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -137,8 +137,6 @@ isert_create_qp(struct isert_conn *isert_conn,
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS + 1;
 	attr.cap.max_rdma_ctxs = ISCSI_DEF_XMIT_CMDS_MAX;
 	attr.cap.max_send_sge = device->ib_device->attrs.max_sge;
-	isert_conn->max_sge = min(device->ib_device->attrs.max_sge,
-				  device->ib_device->attrs.max_sge_rd);
 	attr.cap.max_recv_sge = 1;
 	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	attr.qp_type = IB_QPT_RC;
@@ -151,6 +149,9 @@ isert_create_qp(struct isert_conn *isert_conn,
 		return ERR_PTR(ret);
 	}
 
+	isert_conn->max_send_sge = attr.cap.max_send_sge;
+	isert_conn->max_recv_sge = attr.cap.max_recv_sge;
+
 	return cma_id->qp;
 }
 
@@ -2075,7 +2076,6 @@ static int
 isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
 		struct ib_cqe *cqe, struct ib_send_wr *chain_wr)
 {
-	struct ib_device *dev = conn->device->ib_device;
 	struct se_cmd *se_cmd = &cmd->iscsi_cmd->se_cmd;
 	enum dma_data_direction dir = target_reverse_dma_direction(se_cmd);
 	u8 port_num = conn->cm_id->port_num;
@@ -2087,12 +2087,12 @@ isert_rdma_rw_ctx_post(struct isert_cmd *cmd, struct isert_conn *conn,
 		addr = cmd->write_va;
 		rkey = cmd->write_stag;
 		offset = cmd->iscsi_cmd->write_data_done;
-		max_sge = dev->attrs.max_sge_rd;
+		max_sge = conn->max_recv_sge;
 	} else {
 		addr = cmd->read_va;
 		rkey = cmd->read_stag;
 		offset = 0;
-		max_sge = dev->attrs.max_sge;
+		max_sge = conn->max_send_sge;
 	}
 
 	if (isert_prot_cmd(conn, se_cmd)) {
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index e512ba9..ccd6927 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -138,7 +138,8 @@ struct isert_conn {
 	u32			responder_resources;
 	u32			initiator_depth;
 	bool			pi_support;
-	u32			max_sge;
+	u32			max_send_sge;
+	u32			max_recv_sge;
 	struct iser_rx_desc	*login_req_buf;
 	char			*login_rsp_buf;
 	u64			login_req_dma;
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
