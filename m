From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 04/15] IB/hfi1: Get rid of divide when setting the tx
 request header
Date: Thu, 04 May 2017 05:14:16 -0700
Message-ID: <20170504121415.32747.51843.stgit@scvm10.sc.intel.com>
References: <20170504120126.32747.45131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170504120126.32747.45131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Div instructions show costly in profiles when
the tx request header is set. Using right shift
instead of a divide operation reduces the cycles
spent in the function that sets the tx request
header as shown in the profile. Use right shift
operation instead.

Profile before change:
43.24%  009
|
|--23.41%-- user_sdma_send_pkts
|          |
|          |--99.90%-- hfi1_user_sdma_process_requestAfter:

Profile after change:
45.75%  009
|
|--14.81%-- user_sdma_send_pkts
|          |
|          |--99.95%-- hfi1_user_sdma_process_request

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_sdma.c |   34 ++++++++++++++++----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 0749689..8adb6df 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -143,7 +143,9 @@
 
 /* KDETH OM multipliers and switch over point */
 #define KDETH_OM_SMALL     4
+#define KDETH_OM_SMALL_SHIFT     2
 #define KDETH_OM_LARGE     64
+#define KDETH_OM_LARGE_SHIFT     6
 #define KDETH_OM_MAX_SIZE  (1 << ((KDETH_OM_LARGE / KDETH_OM_SMALL) + 1))
 
 /* Tx request flag bits */
@@ -229,12 +231,6 @@ struct user_sdma_request {
 	 */
 	u32 tidoffset;
 	/*
-	 * KDETH.OM
-	 * Remember this because the header template always sets it
-	 * to 0.
-	 */
-	u8 omfactor;
-	/*
 	 * We copy the iovs for this request (based on
 	 * info.iovcnt). These are only the data vectors
 	 */
@@ -1323,6 +1319,7 @@ static int set_txreq_header(struct user_sdma_request *req,
 {
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
 	struct hfi1_pkt_header *hdr = &tx->hdr;
+	u8 omfactor; /* KDETH.OM */
 	u16 pbclen;
 	int ret;
 	u32 tidval = 0, lrhlen = get_lrh_len(*hdr, pad_len(datalen));
@@ -1400,8 +1397,9 @@ static int set_txreq_header(struct user_sdma_request *req,
 			}
 			tidval = req->tids[req->tididx];
 		}
-		req->omfactor = EXP_TID_GET(tidval, LEN) * PAGE_SIZE >=
-			KDETH_OM_MAX_SIZE ? KDETH_OM_LARGE : KDETH_OM_SMALL;
+		omfactor = EXP_TID_GET(tidval, LEN) * PAGE_SIZE >=
+			KDETH_OM_MAX_SIZE ? KDETH_OM_LARGE_SHIFT :
+			KDETH_OM_SMALL_SHIFT;
 		/* Set KDETH.TIDCtrl based on value for this TID. */
 		KDETH_SET(hdr->kdeth.ver_tid_offset, TIDCTRL,
 			  EXP_TID_GET(tidval, CTRL));
@@ -1416,12 +1414,12 @@ static int set_txreq_header(struct user_sdma_request *req,
 		 * transfer.
 		 */
 		SDMA_DBG(req, "TID offset %ubytes %uunits om%u",
-			 req->tidoffset, req->tidoffset / req->omfactor,
-			 req->omfactor != KDETH_OM_SMALL);
+			 req->tidoffset, req->tidoffset >> omfactor,
+			 omfactor != KDETH_OM_SMALL_SHIFT);
 		KDETH_SET(hdr->kdeth.ver_tid_offset, OFFSET,
-			  req->tidoffset / req->omfactor);
+			  req->tidoffset >> omfactor);
 		KDETH_SET(hdr->kdeth.ver_tid_offset, OM,
-			  req->omfactor != KDETH_OM_SMALL);
+			  omfactor != KDETH_OM_SMALL_SHIFT);
 	}
 done:
 	trace_hfi1_sdma_user_header(pq->dd, pq->ctxt, pq->subctxt,
@@ -1433,6 +1431,7 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 				struct user_sdma_txreq *tx, u32 len)
 {
 	int diff = 0;
+	u8 omfactor; /* KDETH.OM */
 	struct hfi1_user_sdma_pkt_q *pq = req->pq;
 	struct hfi1_pkt_header *hdr = &req->hdr;
 	u16 pbclen = le16_to_cpu(hdr->pbc[0]);
@@ -1484,14 +1483,15 @@ static int set_txreq_header_ahg(struct user_sdma_request *req,
 			}
 			tidval = req->tids[req->tididx];
 		}
-		req->omfactor = ((EXP_TID_GET(tidval, LEN) *
+		omfactor = ((EXP_TID_GET(tidval, LEN) *
 				  PAGE_SIZE) >=
-				 KDETH_OM_MAX_SIZE) ? KDETH_OM_LARGE :
-			KDETH_OM_SMALL;
+				 KDETH_OM_MAX_SIZE) ? KDETH_OM_LARGE_SHIFT :
+				 KDETH_OM_SMALL_SHIFT;
 		/* KDETH.OM and KDETH.OFFSET (TID) */
 		AHG_HEADER_SET(req->ahg, diff, 7, 0, 16,
-			       ((!!(req->omfactor - KDETH_OM_SMALL)) << 15 |
-				((req->tidoffset / req->omfactor) & 0x7fff)));
+			       ((!!(omfactor - KDETH_OM_SMALL_SHIFT)) << 15 |
+				((req->tidoffset >> omfactor)
+				 & 0x7fff)));
 		/* KDETH.TIDCtrl, KDETH.TID, KDETH.Intr, KDETH.SH */
 		val = cpu_to_le16(((EXP_TID_GET(tidval, CTRL) & 0x3) << 10) |
 				   (EXP_TID_GET(tidval, IDX) & 0x3ff));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
