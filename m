From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] RDMA/nes: Fixes for the MPA V2 implementation
Date: Tue, 11 Mar 2014 14:17:25 -0500
Message-ID: <20140311191725.GA29416@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Fixes to enable the negotiation of the supported ird/ord sizes with the
peer when exchanging MPA V2 messages in connection establishment

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |  119 +++++++++++++++++++++++++++---------
 drivers/infiniband/hw/nes/nes_cm.h |    3 +
 2 files changed, 93 insertions(+), 29 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 9c9f2f5..e852a3a 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -128,6 +128,7 @@ static void build_mpa_v1(struct nes_cm_node *, void *, u8);
 static void build_rdma0_msg(struct nes_cm_node *, struct nes_qp **);
 
 static void print_core(struct nes_cm_core *core);
+static void record_ird_ord(struct nes_cm_node *, u16, u16);
 
 /* External CM API Interface */
 /* instance of function pointers for client API */
@@ -317,7 +318,6 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
 		}
 	}
 
-
 	if (priv_data_len + mpa_hdr_len != len) {
 		nes_debug(NES_DBG_CM, "The received ietf buffer was not right"
 			" complete (%x + %x != %x)\n",
@@ -356,25 +356,57 @@ static int parse_mpa(struct nes_cm_node *cm_node, u8 *buffer, u32 *type,
 			/* send reset */
 			return -EINVAL;
 		}
+		if (ird_size == IETF_NO_IRD_ORD || ord_size == IETF_NO_IRD_ORD)
+			cm_node->mpav2_ird_ord = IETF_NO_IRD_ORD;
 
-		if (cm_node->state != NES_CM_STATE_MPAREQ_SENT) {
+		if (cm_node->mpav2_ird_ord != IETF_NO_IRD_ORD) {
 			/* responder */
-			if (cm_node->ord_size > ird_size)
-				cm_node->ord_size = ird_size;
-		} else {
-			/* initiator */
-			if (cm_node->ord_size > ird_size)
-				cm_node->ord_size = ird_size;
-
-			if (cm_node->ird_size < ord_size) {
-				/* no resources available */
-				/* send terminate message */
-				return -EINVAL;
+			if (cm_node->state != NES_CM_STATE_MPAREQ_SENT) {
+				/* we are still negotiating */
+				if (ord_size > NES_MAX_IRD) {
+					cm_node->ird_size = NES_MAX_IRD;
+				} else {
+					cm_node->ird_size = ord_size;
+					if (ord_size == 0 &&
+					(rtr_ctrl_ord & IETF_RDMA0_READ)) {
+						cm_node->ird_size = 1;
+						nes_debug(NES_DBG_CM,
+						"%s: Remote peer doesn't support RDMA0_READ (ord=%u)\n",
+							__func__, ord_size);
+					}
+				}
+				if (ird_size > NES_MAX_ORD)
+					cm_node->ord_size = NES_MAX_ORD;
+				else
+					cm_node->ord_size = ird_size;
+			} else { /* initiator */
+				if (ord_size > NES_MAX_IRD) {
+					nes_debug(NES_DBG_CM,
+					"%s: Unable to support the requested (ord =%u)\n",
+							__func__, ord_size);
+					return -EINVAL;
+				}
+				cm_node->ird_size = ord_size;
+
+				if (ird_size > NES_MAX_ORD) {
+					cm_node->ord_size = NES_MAX_ORD;
+				} else {
+					if (ird_size == 0 &&
+					(rtr_ctrl_ord & IETF_RDMA0_READ)) {
+						nes_debug(NES_DBG_CM,
+						"%s: Remote peer doesn't support RDMA0_READ (ird=%u)\n",
+							__func__, ird_size);
+						return -EINVAL;
+					} else {
+						cm_node->ord_size = ird_size;
+					}
+				}
 			}
 		}
 
 		if (rtr_ctrl_ord & IETF_RDMA0_READ) {
 			cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
+
 		} else if (rtr_ctrl_ord & IETF_RDMA0_WRITE) {
 			cm_node->send_rdma0_op = SEND_RDMA_WRITE_ZERO;
 		} else {        /* Not supported RDMA0 operation */
@@ -514,6 +546,19 @@ static void print_core(struct nes_cm_core *core)
 	nes_debug(NES_DBG_CM, "-------------- end core ---------------\n");
 }
 
+static void record_ird_ord(struct nes_cm_node *cm_node,
+					u16 conn_ird, u16 conn_ord)
+{
+	if (conn_ird > NES_MAX_IRD)
+		conn_ird = NES_MAX_IRD;
+
+	if (conn_ord > NES_MAX_ORD)
+		conn_ord = NES_MAX_ORD;
+
+	cm_node->ird_size = conn_ird;
+	cm_node->ord_size = conn_ord;
+}
+
 /**
  * cm_build_mpa_frame - build a MPA V1 frame or MPA V2 frame
  */
@@ -557,11 +602,13 @@ static void build_mpa_v2(struct nes_cm_node *cm_node,
 	mpa_frame->priv_data_len += htons(IETF_RTR_MSG_SIZE);
 
 	/* initialize RTR msg */
-	ctrl_ird = (cm_node->ird_size > IETF_NO_IRD_ORD) ?
-			    IETF_NO_IRD_ORD : cm_node->ird_size;
-	ctrl_ord = (cm_node->ord_size > IETF_NO_IRD_ORD) ?
-			    IETF_NO_IRD_ORD : cm_node->ord_size;
-
+	if (cm_node->mpav2_ird_ord == IETF_NO_IRD_ORD) {
+		ctrl_ird = IETF_NO_IRD_ORD;
+		ctrl_ord = IETF_NO_IRD_ORD;
+	} else {
+		ctrl_ird = cm_node->ird_size & IETF_NO_IRD_ORD;
+		ctrl_ord = cm_node->ord_size & IETF_NO_IRD_ORD;
+	}
 	ctrl_ird |= IETF_PEER_TO_PEER;
 	ctrl_ird |= IETF_FLPDU_ZERO_LEN;
 
@@ -1409,8 +1456,9 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 
 	cm_node->mpa_frame_rev = mpa_version;
 	cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
-	cm_node->ird_size = IETF_NO_IRD_ORD;
-	cm_node->ord_size = IETF_NO_IRD_ORD;
+	cm_node->mpav2_ird_ord = 0;
+	cm_node->ird_size = 0;
+	cm_node->ord_size = 0;
 
 	nes_debug(NES_DBG_CM, "Make node addresses : loc = %pI4:%x, rem = %pI4:%x\n",
 		  &cm_node->loc_addr, cm_node->loc_port,
@@ -3027,11 +3075,11 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		rem_ref_cm_node(cm_node->cm_core, cm_node);
 		return -ECONNRESET;
 	}
-
 	/* associate the node with the QP */
 	nesqp->cm_node = (void *)cm_node;
 	cm_node->nesqp = nesqp;
 
+
 	nes_debug(NES_DBG_CM, "QP%u, cm_node=%p, jiffies = %lu listener = %p\n",
 		nesqp->hwqp.qp_id, cm_node, jiffies, cm_node->listener);
 	atomic_inc(&cm_accepts);
@@ -3054,6 +3102,11 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (cm_node->mpa_frame_rev == IETF_MPA_V1)
 		mpa_frame_offset = 4;
 
+	if (cm_node->mpa_frame_rev == IETF_MPA_V1 ||
+			cm_node->mpav2_ird_ord == IETF_NO_IRD_ORD) {
+		record_ird_ord(cm_node, (u16)conn_param->ird, (u16)conn_param->ord);
+	}
+
 	memcpy(mpa_v2_frame->priv_data, conn_param->private_data,
 	       conn_param->private_data_len);
 
@@ -3117,7 +3170,6 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	}
 	nesqp->skip_lsmm = 1;
 
-
 	/* Cache the cm_id in the qp */
 	nesqp->cm_id = cm_id;
 	cm_node->cm_id = cm_id;
@@ -3154,7 +3206,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32(
 		((u32)1 << NES_QPCONTEXT_ORDIRD_IWARP_MODE_SHIFT));
 	nesqp->nesqp_context->ird_ord_sizes |=
-		cpu_to_le32((u32)conn_param->ord);
+		cpu_to_le32((u32)cm_node->ord_size);
 
 	memset(&nes_quad, 0, sizeof(nes_quad));
 	nes_quad.DstIpAdrIndex =
@@ -3194,6 +3246,9 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	cm_event.remote_addr = cm_id->remote_addr;
 	cm_event.private_data = NULL;
 	cm_event.private_data_len = 0;
+	cm_event.ird = cm_node->ird_size;
+	cm_event.ord = cm_node->ord_size;
+
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	attr.qp_state = IB_QPS_RTS;
 	nes_modify_qp(&nesqp->ibqp, &attr, IB_QP_STATE, NULL);
@@ -3290,14 +3345,8 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	/* cache the cm_id in the qp */
 	nesqp->cm_id = cm_id;
-
 	cm_id->provider_data = nesqp;
-
 	nesqp->private_data_len = conn_param->private_data_len;
-	nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32((u32)conn_param->ord);
-	/* space for rdma0 read msg */
-	if (conn_param->ord == 0)
-		nesqp->nesqp_context->ird_ord_sizes |= cpu_to_le32(1);
 
 	nes_debug(NES_DBG_CM, "requested ord = 0x%08X.\n", (u32)conn_param->ord);
 	nes_debug(NES_DBG_CM, "mpa private data len =%u\n",
@@ -3334,6 +3383,11 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		return -ENOMEM;
 	}
 
+	record_ird_ord(cm_node, (u16)conn_param->ird, (u16)conn_param->ord);
+	if (cm_node->send_rdma0_op == SEND_RDMA_READ_ZERO &&
+				cm_node->ord_size == 0)
+		cm_node->ord_size = 1;
+
 	cm_node->apbvt_set = apbvt_set;
 	nesqp->cm_node = cm_node;
 	cm_node->nesqp = nesqp;
@@ -3530,6 +3584,8 @@ static void cm_event_connected(struct nes_cm_event *event)
 	nesqp->nesqp_context->ird_ord_sizes |=
 			cpu_to_le32((u32)1 <<
 			NES_QPCONTEXT_ORDIRD_IWARP_MODE_SHIFT);
+	nesqp->nesqp_context->ird_ord_sizes |=
+			cpu_to_le32((u32)cm_node->ord_size);
 
 	/* Adjust tail for not having a LSMM */
 	/*nesqp->hwqp.sq_tail = 1;*/
@@ -3742,8 +3798,13 @@ static void cm_event_mpa_req(struct nes_cm_event *event)
 	cm_event_raddr->sin_addr.s_addr = htonl(event->cm_info.rem_addr);
 	cm_event.private_data = cm_node->mpa_frame_buf;
 	cm_event.private_data_len = (u8)cm_node->mpa_frame_size;
+	if (cm_node->mpa_frame_rev == IETF_MPA_V1) {
+		cm_event.ird = NES_MAX_IRD;
+		cm_event.ord = NES_MAX_ORD;
+	} else {
 	cm_event.ird = cm_node->ird_size;
 	cm_event.ord = cm_node->ord_size;
+	}
 
 	ret = cm_id->event_handler(cm_id, &cm_event);
 	if (ret)
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index 4646e66..522c99c 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -58,6 +58,8 @@
 #define IETF_RDMA0_WRITE        0x8000
 #define IETF_RDMA0_READ         0x4000
 #define IETF_NO_IRD_ORD         0x3FFF
+#define NES_MAX_IRD		 0x40
+#define NES_MAX_ORD		 0x7F
 
 enum ietf_mpa_flags {
 	IETF_MPA_FLAGS_MARKERS = 0x80,	/* receive Markers */
@@ -333,6 +335,7 @@ struct nes_cm_node {
 	enum mpa_frame_version    mpa_frame_rev;
 	u16			  ird_size;
 	u16                       ord_size;
+	u16			  mpav2_ird_ord;
 
 	u16                       mpa_frame_size;
 	struct iw_cm_id           *cm_id;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
