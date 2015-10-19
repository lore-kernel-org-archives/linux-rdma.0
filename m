From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 01/23] staging/rdma/hfi1: inline clear_ahg()
Date: Mon, 19 Oct 2015 12:43:25 -0400
Message-ID: <1445273027-29634-2-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This additional call is a regression from
qib.  For small messages the progress routine
always builds one and clears out the ahg
state when the queue has gone to empty which
is the predominant case for small messages.

Inline the routine to mitigate the call and move
the routine to qp.h for scope reasons.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
 drivers/staging/rdma/hfi1/qp.h    | 15 +++++++++++++++
 drivers/staging/rdma/hfi1/ruc.c   | 13 -------------
 drivers/staging/rdma/hfi1/verbs.h |  2 --
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index 6b505859b59c..b9c1575990aa 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -52,6 +52,7 @@
 
 #include <linux/hash.h>
 #include "verbs.h"
+#include "sdma.h"
 
 #define QPN_MAX                 (1 << 24)
 #define QPNMAP_ENTRIES          (QPN_MAX / PAGE_SIZE / BITS_PER_BYTE)
@@ -117,6 +118,20 @@ static inline struct hfi1_qp *hfi1_lookup_qpn(struct hfi1_ibport *ibp,
 }
 
 /**
+ * clear_ahg - reset ahg status in qp
+ * @qp - qp pointer
+ */
+static inline void clear_ahg(struct hfi1_qp *qp)
+{
+	qp->s_hdr->ahgcount = 0;
+	qp->s_flags &= ~(HFI1_S_AHG_VALID | HFI1_S_AHG_CLEAR);
+	if (qp->s_sde && qp->s_ahgidx >= 0)
+		sdma_ahg_free(qp->s_sde, qp->s_ahgidx);
+	qp->s_ahgidx = -1;
+	qp->s_sde = NULL;
+}
+
+/**
  * hfi1_error_qp - put a QP into the error state
  * @qp: the QP to put into the error state
  * @err: the receive completion error to signal if a RWQE is active
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index a4115288db66..faad1b93703e 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -695,19 +695,6 @@ u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 	return sizeof(struct ib_grh) / sizeof(u32);
 }
 
-/*
- * free_ahg - clear ahg from QP
- */
-void clear_ahg(struct hfi1_qp *qp)
-{
-	qp->s_hdr->ahgcount = 0;
-	qp->s_flags &= ~(HFI1_S_AHG_VALID | HFI1_S_AHG_CLEAR);
-	if (qp->s_sde)
-		sdma_ahg_free(qp->s_sde, qp->s_ahgidx);
-	qp->s_ahgidx = -1;
-	qp->s_sde = NULL;
-}
-
 #define BTH2_OFFSET (offsetof(struct hfi1_pio_header, hdr.u.oth.bth[2]) / 4)
 
 /**
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index ed903a93baf7..afaa0fe619fe 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -1078,8 +1078,6 @@ int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 u32 hfi1_make_grh(struct hfi1_ibport *ibp, struct ib_grh *hdr,
 		  struct ib_global_route *grh, u32 hwords, u32 nwords);
 
-void clear_ahg(struct hfi1_qp *qp);
-
 void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 			  u32 bth0, u32 bth2, int middle);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
