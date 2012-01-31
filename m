From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: Fixes for Sparse Endian related warnings
Date: Tue, 31 Jan 2012 15:19:47 -0600
Message-ID: <20120131211947.GA10244@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes for Endian Sparse Warnings introduced with the enhanced MPA patch 

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Faisal Latif <Faisal.Latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |   39 ++++++++++++++++++++---------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index a4972ab..da2c67d 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -338,18 +338,21 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
 	case IETF_MPA_V2: {
 		u16 ird_size;
 		u16 ord_size;
+		u16 rtr_ctrl_ird;
+		u16 rtr_ctrl_ord;
+
 		mpa_v2_frame = (struct ietf_mpa_v2 *)buffer;
 		mpa_hdr_len += IETF_RTR_MSG_SIZE;
 		cm_node->mpa_frame_size -= IETF_RTR_MSG_SIZE;
 		rtr_msg = &mpa_v2_frame->rtr_msg;
 
 		/* parse rtr message */
-		rtr_msg->ctrl_ird = ntohs(rtr_msg->ctrl_ird);
-		rtr_msg->ctrl_ord = ntohs(rtr_msg->ctrl_ord);
-		ird_size = rtr_msg->ctrl_ird & IETF_NO_IRD_ORD;
-		ord_size = rtr_msg->ctrl_ord & IETF_NO_IRD_ORD;
+		rtr_ctrl_ird = ntohs(rtr_msg->ctrl_ird);
+		rtr_ctrl_ord = ntohs(rtr_msg->ctrl_ord);
+		ird_size = rtr_ctrl_ird & IETF_NO_IRD_ORD;
+		ord_size = rtr_ctrl_ord & IETF_NO_IRD_ORD;
 
-		if (!(rtr_msg->ctrl_ird & IETF_PEER_TO_PEER)) {
+		if (!(rtr_ctrl_ird & IETF_PEER_TO_PEER)) {
 			/* send reset */
 			return -EINVAL;
 		}
@@ -370,9 +373,9 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
 			}
 		}
 
-		if (rtr_msg->ctrl_ord & IETF_RDMA0_READ) {
+		if (rtr_ctrl_ord & IETF_RDMA0_READ) {
 			cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
-		} else if (rtr_msg->ctrl_ord & IETF_RDMA0_WRITE) {
+		} else if (rtr_ctrl_ord & IETF_RDMA0_WRITE) {
 			cm_node->send_rdma0_op = SEND_RDMA_WRITE_ZERO;
 		} else {        /* Not supported RDMA0 operation */
 			return -EINVAL;
@@ -543,6 +546,8 @@ static void build_mpa_v2(struct nes_cm_node *cm_node,
 {
 	struct ietf_mpa_v2 *mpa_frame = (struct ietf_mpa_v2 *)start_addr;
 	struct ietf_rtr_msg *rtr_msg = &mpa_frame->rtr_msg;
+	u16 ctrl_ird;
+	u16 ctrl_ord;
 
 	/* initialize the upper 5 bytes of the frame */
 	build_mpa_v1(cm_node, start_addr, mpa_key);
@@ -550,31 +555,31 @@ static void build_mpa_v2(struct nes_cm_node *cm_node,
 	mpa_frame->priv_data_len += htons(IETF_RTR_MSG_SIZE);
 
 	/* initialize RTR msg */
-	rtr_msg->ctrl_ird = (cm_node->ird_size > IETF_NO_IRD_ORD) ?
+	ctrl_ird = (cm_node->ird_size > IETF_NO_IRD_ORD) ?
 			    IETF_NO_IRD_ORD : cm_node->ird_size;
-	rtr_msg->ctrl_ord = (cm_node->ord_size > IETF_NO_IRD_ORD) ?
+	ctrl_ord = (cm_node->ord_size > IETF_NO_IRD_ORD) ?
 			    IETF_NO_IRD_ORD : cm_node->ord_size;
 
-	rtr_msg->ctrl_ird |= IETF_PEER_TO_PEER;
-	rtr_msg->ctrl_ird |= IETF_FLPDU_ZERO_LEN;
+	ctrl_ird |= IETF_PEER_TO_PEER;
+	ctrl_ird |= IETF_FLPDU_ZERO_LEN;
 
 	switch (mpa_key) {
 	case MPA_KEY_REQUEST:
-		rtr_msg->ctrl_ord |= IETF_RDMA0_WRITE;
-		rtr_msg->ctrl_ord |= IETF_RDMA0_READ;
+		ctrl_ord |= IETF_RDMA0_WRITE;
+		ctrl_ord |= IETF_RDMA0_READ;
 		break;
 	case MPA_KEY_REPLY:
 		switch (cm_node->send_rdma0_op) {
 		case SEND_RDMA_WRITE_ZERO:
-			rtr_msg->ctrl_ord |= IETF_RDMA0_WRITE;
+			ctrl_ord |= IETF_RDMA0_WRITE;
 			break;
 		case SEND_RDMA_READ_ZERO:
-			rtr_msg->ctrl_ord |= IETF_RDMA0_READ;
+			ctrl_ord |= IETF_RDMA0_READ;
 			break;
 		}
 	}
-	rtr_msg->ctrl_ird = htons(rtr_msg->ctrl_ird);
-	rtr_msg->ctrl_ord = htons(rtr_msg->ctrl_ord);
+	rtr_msg->ctrl_ird = htons(ctrl_ird);
+	rtr_msg->ctrl_ord = htons(ctrl_ord);
 }
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
