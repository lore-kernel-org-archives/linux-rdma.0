From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 2/4] RDMA/libocrdma: set vlan present bit for UD
Date: Mon,  2 Nov 2015 01:37:23 -0500
Message-ID: <1446446245-534-3-git-send-email-devesh.sharma@avagotech.com>
References: <1446446245-534-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446446245-534-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch tells f/w about the presence of VLAN tag in
the AH being supplied to the QP.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 src/ocrdma_abi.h   | 7 ++++---
 src/ocrdma_main.h  | 7 +++++++
 src/ocrdma_verbs.c | 8 ++++++--
 3 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/src/ocrdma_abi.h b/src/ocrdma_abi.h
index ad7abd4..8102c1c 100644
--- a/src/ocrdma_abi.h
+++ b/src/ocrdma_abi.h
@@ -51,14 +51,14 @@ enum {
 };
 
 #define OCRDMA_DB_CQ_RING_ID_MASK		0x3FF	/* bits 0 - 9 */
-#define OCRDMA_DB_CQ_RING_ID_EXT_MASK  0x0C00	/* bits 10-11 of qid placing at 12-11 */
-#define OCRDMA_DB_CQ_RING_ID_EXT_MASK_SHIFT  0x1	/* qid #2 msbits placing at 12-11 */
+#define OCRDMA_DB_CQ_RING_ID_EXT_MASK		0x0C00	/* bits 10-11 of qid placing at 12-11 */
+#define OCRDMA_DB_CQ_RING_ID_EXT_MASK_SHIFT	0x1	/* qid #2 msbits placing at 12-11 */
 #define OCRDMA_DB_CQ_NUM_POPPED_SHIFT		(16)	/* bits 16 - 28 */
 /* Rearm bit */
 #define OCRDMA_DB_CQ_REARM_SHIFT		(29)	/* bit 29 */
 
 /* solicited bit */
-#define OCRDMA_DB_CQ_SOLICIT_SHIFT   (31)	/* bit 31 */
+#define OCRDMA_DB_CQ_SOLICIT_SHIFT		(31)	/* bit 31 */
 
 struct ocrdma_get_context {
 	struct ibv_get_context cmd;
@@ -291,6 +291,7 @@ enum {
 	OCRDMA_FLAG_FENCE_R 	= 0x8,
 	OCRDMA_FLAG_SOLICIT	= 0x10,
 	OCRDMA_FLAG_IMM 	= 0x20,
+	OCRDMA_FLAG_AH_VLAN_PR	= 0x40,
 
 	/* Stag flags */
 	OCRDMA_LKEY_FLAG_LOCAL_WR 	= 0x1,
diff --git a/src/ocrdma_main.h b/src/ocrdma_main.h
index 5a386bb..4e7be75 100644
--- a/src/ocrdma_main.h
+++ b/src/ocrdma_main.h
@@ -211,10 +211,17 @@ struct ocrdma_qp {
 	int	signaled;	/* signaled QP */
 };
 
+enum {
+	OCRDMA_AH_ID_MASK               = 0x3FF,
+	OCRDMA_AH_VLAN_VALID_MASK       = 0x01,
+	OCRDMA_AH_VLAN_VALID_SHIFT      = 0x1F
+};
+
 struct ocrdma_ah {
 	struct ibv_ah ibv_ah;
 	struct ocrdma_pd *pd;
 	uint16_t id;
+	uint8_t isvlan;
 };
 
 #define get_ocrdma_xxx(xxx, type)				\
diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index ab90b4f..d80ab27 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -1196,6 +1196,9 @@ static void ocrdma_build_ud_hdr(struct ocrdma_qp *qp,
 	ud_hdr->rsvd_dest_qpn = wr->wr.ud.remote_qpn;
 	ud_hdr->qkey = wr->wr.ud.remote_qkey;
 	ud_hdr->rsvd_ahid = ah->id;
+	if (ah->isvlan)
+		hdr->cw |= (OCRDMA_FLAG_AH_VLAN_PR <<
+			    OCRDMA_WQE_FLAGS_SHIFT);
 }
 
 static void ocrdma_build_sges(struct ocrdma_hdr_wqe *hdr,
@@ -2156,9 +2159,10 @@ struct ibv_ah *ocrdma_create_ah(struct ibv_pd *ibpd, struct ibv_ah_attr *attr)
 	if (status)
 		goto cmd_err;
 
-	ah->id = pd->uctx->ah_tbl[ahtbl_idx];
+	ah->id = pd->uctx->ah_tbl[ahtbl_idx] & OCRDMA_AH_ID_MASK;
+	ah->isvlan = (pd->uctx->ah_tbl[ahtbl_idx] >>
+			OCRDMA_AH_VLAN_VALID_SHIFT);
 	return &ah->ibv_ah;
-
 cmd_err:
 	ocrdma_free_ah_tbl_id(pd->uctx, ahtbl_idx);
 tbl_err:
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
