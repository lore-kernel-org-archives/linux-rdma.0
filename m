From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next] IB/iser: Suppress completion for fast registration work requests
Date: Thu, 23 Jan 2014 12:31:28 +0200
Message-ID: <1390473088-5160-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

In case iSER uses fast registration method, it should not
request for successful completions on fast registration nor
local invalidate. We color wr_id with ISER_FRWR_LI_WRID in
order to correctly consume error completions.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |    2 ++
 drivers/infiniband/ulp/iser/iser_memory.c |   15 ++++-----------
 drivers/infiniband/ulp/iser/iser_verbs.c  |   14 ++++++--------
 3 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 6791402..e1a01c6 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -138,6 +138,8 @@
 #define ISER_WSV			0x08
 #define ISER_RSV			0x04
 
+#define ISER_FRWR_LI_WRID		0xffffffffffffffffULL
+
 struct iser_hdr {
 	u8      flags;
 	u8      rsvd[3];
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 1ce0c97..f770179 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -457,8 +457,8 @@ static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
 
 	if (!desc->valid) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
+		inv_wr.wr_id = ISER_FRWR_LI_WRID;
 		inv_wr.opcode = IB_WR_LOCAL_INV;
-		inv_wr.send_flags = IB_SEND_SIGNALED;
 		inv_wr.ex.invalidate_rkey = desc->data_mr->rkey;
 		wr = &inv_wr;
 		/* Bump the key */
@@ -468,8 +468,8 @@ static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
 
 	/* Prepare FASTREG WR */
 	memset(&fastreg_wr, 0, sizeof(fastreg_wr));
+	fastreg_wr.wr_id = ISER_FRWR_LI_WRID;
 	fastreg_wr.opcode = IB_WR_FAST_REG_MR;
-	fastreg_wr.send_flags = IB_SEND_SIGNALED;
 	fastreg_wr.wr.fast_reg.iova_start = desc->data_frpl->page_list[0] + offset;
 	fastreg_wr.wr.fast_reg.page_list = desc->data_frpl;
 	fastreg_wr.wr.fast_reg.page_list_len = page_list_len;
@@ -480,20 +480,13 @@ static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
 					       IB_ACCESS_REMOTE_WRITE |
 					       IB_ACCESS_REMOTE_READ);
 
-	if (!wr) {
+	if (!wr)
 		wr = &fastreg_wr;
-		atomic_inc(&ib_conn->post_send_buf_count);
-	} else {
+	else
 		wr->next = &fastreg_wr;
-		atomic_add(2, &ib_conn->post_send_buf_count);
-	}
 
 	ret = ib_post_send(ib_conn->qp, wr, &bad_wr);
 	if (ret) {
-		if (bad_wr->next)
-			atomic_sub(2, &ib_conn->post_send_buf_count);
-		else
-			atomic_dec(&ib_conn->post_send_buf_count);
 		iser_err("fast registration failed, ret:%d\n", ret);
 		return ret;
 	}
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index afe9567..6f441dd 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -989,18 +989,16 @@ static int iser_drain_tx_cq(struct iser_device  *device, int cq_index)
 		if (wc.status == IB_WC_SUCCESS) {
 			if (wc.opcode == IB_WC_SEND)
 				iser_snd_completion(tx_desc, ib_conn);
-			else if (wc.opcode == IB_WC_LOCAL_INV ||
-				 wc.opcode == IB_WC_FAST_REG_MR) {
-				atomic_dec(&ib_conn->post_send_buf_count);
-				continue;
-			} else
+			else
 				iser_err("expected opcode %d got %d\n",
 					IB_WC_SEND, wc.opcode);
 		} else {
 			iser_err("tx id %llx status %d vend_err %x\n",
-				wc.wr_id, wc.status, wc.vendor_err);
-			atomic_dec(&ib_conn->post_send_buf_count);
-			iser_handle_comp_error(tx_desc, ib_conn);
+				 wc.wr_id, wc.status, wc.vendor_err);
+			if (wc.wr_id != ISER_FRWR_LI_WRID) {
+				atomic_dec(&ib_conn->post_send_buf_count);
+				iser_handle_comp_error(tx_desc, ib_conn);
+			}
 		}
 		completed_tx++;
 	}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
