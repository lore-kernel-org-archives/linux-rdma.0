From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/4] RDMA/libocrdma: Add user space support for RoCE-v2
Date: Thu, 25 Feb 2016 02:50:44 -0500
Message-ID: <1456386647-22315-2-git-send-email-devesh.sharma@broadcom.com>
References: <1456386647-22315-1-git-send-email-devesh.sharma@broadcom.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456386647-22315-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

RoCE-v2 is a recently added extension to original RoCE protocol
it uses UDP encapsulation to achieve routability of RoCE packets.

This patch avails RoCE-v2 for userland applications.

Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
---
 src/ocrdma_abi.h   | 2 +-
 src/ocrdma_main.h  | 5 ++++-
 src/ocrdma_verbs.c | 4 ++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/ocrdma_abi.h b/src/ocrdma_abi.h
index 8102c1c..8670a1d 100644
--- a/src/ocrdma_abi.h
+++ b/src/ocrdma_abi.h
@@ -350,7 +350,7 @@ struct ocrdma_ewqe_ud_hdr {
 	uint32_t rsvd_dest_qpn;
 	uint32_t qkey;
 	uint32_t rsvd_ahid;
-	uint32_t rsvd;
+	uint32_t hdr_type;
 } __attribute__ ((packed));
 
 #endif				/* __OCRDMA_ABI_H__ */
diff --git a/src/ocrdma_main.h b/src/ocrdma_main.h
index 4e7be75..c81188b 100644
--- a/src/ocrdma_main.h
+++ b/src/ocrdma_main.h
@@ -214,7 +214,9 @@ struct ocrdma_qp {
 enum {
 	OCRDMA_AH_ID_MASK               = 0x3FF,
 	OCRDMA_AH_VLAN_VALID_MASK       = 0x01,
-	OCRDMA_AH_VLAN_VALID_SHIFT      = 0x1F
+	OCRDMA_AH_VLAN_VALID_SHIFT      = 0x1F,
+	OCRDMA_AH_L3_TYPE_MASK		= 0x03,
+	OCRDMA_AH_L3_TYPE_SHIFT		= 0x1D
 };
 
 struct ocrdma_ah {
@@ -222,6 +224,7 @@ struct ocrdma_ah {
 	struct ocrdma_pd *pd;
 	uint16_t id;
 	uint8_t isvlan;
+	uint8_t hdr_type;
 };
 
 #define get_ocrdma_xxx(xxx, type)				\
diff --git a/src/ocrdma_verbs.c b/src/ocrdma_verbs.c
index cf6f72c..c62ced0 100644
--- a/src/ocrdma_verbs.c
+++ b/src/ocrdma_verbs.c
@@ -1199,6 +1199,7 @@ static void ocrdma_build_ud_hdr(struct ocrdma_qp *qp,
 	if (ah->isvlan)
 		hdr->cw |= (OCRDMA_FLAG_AH_VLAN_PR <<
 			    OCRDMA_WQE_FLAGS_SHIFT);
+	ud_hdr->hdr_type = ah->hdr_type;
 }
 
 static void ocrdma_build_sges(struct ocrdma_hdr_wqe *hdr,
@@ -2159,6 +2160,9 @@ struct ibv_ah *ocrdma_create_ah(struct ibv_pd *ibpd, struct ibv_ah_attr *attr)
 	ah->id = pd->uctx->ah_tbl[ahtbl_idx] & OCRDMA_AH_ID_MASK;
 	ah->isvlan = (pd->uctx->ah_tbl[ahtbl_idx] >>
 			OCRDMA_AH_VLAN_VALID_SHIFT);
+	ah->hdr_type = ((pd->uctx->ah_tbl[ahtbl_idx] >> OCRDMA_AH_L3_TYPE_SHIFT)
+			& OCRDMA_AH_L3_TYPE_MASK);
+
 	return &ah->ibv_ah;
 cmd_err:
 	ocrdma_free_ah_tbl_id(pd->uctx, ahtbl_idx);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
