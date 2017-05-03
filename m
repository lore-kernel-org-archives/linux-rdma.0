From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/15] IB/hfi1: Remove atomic operations for
 SDMA_REQ_HAVE_AHG bit
Date: Tue, 02 May 2017 17:42:00 -0700
Message-ID: <20170503004159.6965.14993.stgit@scvm10.sc.intel.com>
References: <20170503003734.6965.67405.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503003734.6965.67405.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The AHG index is only accessed in the request call
from user space, so there's no need for atomic semantics.
Replace atomic operations for SDMA_REQ_HAVE_AHG bit
with a test of the AHG index.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 4ac4e9d..6b72267 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -155,9 +155,8 @@
 /* SDMA request flag bits */
 #define SDMA_REQ_FOR_THREAD 1
 #define SDMA_REQ_SEND_DONE  2
-#define SDMA_REQ_HAVE_AHG   3
-#define SDMA_REQ_HAS_ERROR  4
-#define SDMA_REQ_DONE_ERROR 5
+#define SDMA_REQ_HAS_ERROR  3
+#define SDMA_REQ_DONE_ERROR 4
 
 #define SDMA_PKT_Q_INACTIVE BIT(0)
 #define SDMA_PKT_Q_ACTIVE   BIT(1)
@@ -216,7 +215,7 @@ struct user_sdma_request {
 	 * each request will need it's own engine pointer.
 	 */
 	struct sdma_engine *sde;
-	u8 ahg_idx;
+	s8 ahg_idx;
 	u32 ahg[9];
 	/*
 	 * KDETH.Offset (Eager) field
@@ -614,6 +613,7 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 	req->pq = pq;
 	req->cq = cq;
 	req->status = -1;
+	req->ahg_idx = -1;
 	INIT_LIST_HEAD(&req->txps);
 
 	memcpy(&req->info, &info, sizeof(info));
@@ -764,14 +764,8 @@ int hfi1_user_sdma_process_request(struct hfi1_filedata *fd,
 	}
 
 	/* We don't need an AHG entry if the request contains only one packet */
-	if (req->info.npkts > 1 && HFI1_CAP_IS_USET(SDMA_AHG)) {
-		int ahg = sdma_ahg_alloc(req->sde);
-
-		if (likely(ahg >= 0)) {
-			req->ahg_idx = (u8)ahg;
-			set_bit(SDMA_REQ_HAVE_AHG, &req->flags);
-		}
-	}
+	if (req->info.npkts > 1 && HFI1_CAP_IS_USET(SDMA_AHG))
+		req->ahg_idx = sdma_ahg_alloc(req->sde);
 
 	set_comp_state(pq, cq, info.comp_idx, QUEUED, 0);
 	atomic_inc(&pq->n_reqs);
@@ -989,7 +983,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 			}
 		}
 
-		if (test_bit(SDMA_REQ_HAVE_AHG, &req->flags)) {
+		if (req->ahg_idx >= 0) {
 			if (!req->seqnum) {
 				u16 pbclen = le16_to_cpu(req->hdr.pbc[0]);
 				u32 lrhlen = get_lrh_len(req->hdr,
@@ -1119,7 +1113,7 @@ static int user_sdma_send_pkts(struct user_sdma_request *req, unsigned maxpkts)
 		 * happen due to the sequential manner in which
 		 * descriptors are processed.
 		 */
-		if (test_bit(SDMA_REQ_HAVE_AHG, &req->flags))
+		if (req->ahg_idx >= 0)
 			sdma_ahg_free(req->sde, req->ahg_idx);
 	}
 	return ret;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
