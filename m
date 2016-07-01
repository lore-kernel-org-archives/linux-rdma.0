From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/18] IB/hfi1: Fix trace sparse errors
Date: Fri, 01 Jul 2016 16:01:11 -0700
Message-ID: <20160701230111.20160.9865.stgit@scvm10.sc.intel.com>
References: <20160701225824.20160.19055.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160701225824.20160.19055.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Fix sparse errors by making sure the fast assign destinations
are host cpu typed.

For the void __iomem *, just make the field match source
data.

Fix a bug where the hw_free trace printed the pointer vs.
the dereferenced value.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/trace_ctxts.h |    8 ++--
 drivers/infiniband/hw/hfi1/trace_tx.h    |   54 +++++++++++++++---------------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/trace_ctxts.h b/drivers/infiniband/hw/hfi1/trace_ctxts.h
index 5052d49..31654bb 100644
--- a/drivers/infiniband/hw/hfi1/trace_ctxts.h
+++ b/drivers/infiniband/hw/hfi1/trace_ctxts.h
@@ -56,7 +56,7 @@
 #define TRACE_SYSTEM hfi1_ctxts
 
 #define UCTXT_FMT \
-	"cred:%u, credaddr:0x%llx, piobase:0x%llx, rcvhdr_cnt:%u, "	\
+	"cred:%u, credaddr:0x%llx, piobase:0x%p, rcvhdr_cnt:%u, "	\
 	"rcvbase:0x%llx, rcvegrc:%u, rcvegrb:0x%llx"
 TRACE_EVENT(hfi1_uctxtdata,
 	    TP_PROTO(struct hfi1_devdata *dd, struct hfi1_ctxtdata *uctxt),
@@ -65,7 +65,7 @@ TRACE_EVENT(hfi1_uctxtdata,
 			     __field(unsigned int, ctxt)
 			     __field(u32, credits)
 			     __field(u64, hw_free)
-			     __field(u64, piobase)
+			     __field(void __iomem *, piobase)
 			     __field(u16, rcvhdrq_cnt)
 			     __field(u64, rcvhdrq_phys)
 			     __field(u32, eager_cnt)
@@ -74,8 +74,8 @@ TRACE_EVENT(hfi1_uctxtdata,
 	    TP_fast_assign(DD_DEV_ASSIGN(dd);
 			   __entry->ctxt = uctxt->ctxt;
 			   __entry->credits = uctxt->sc->credits;
-			   __entry->hw_free = (u64)uctxt->sc->hw_free;
-			   __entry->piobase = (u64)uctxt->sc->base_addr;
+			   __entry->hw_free = le64_to_cpu(*uctxt->sc->hw_free);
+			   __entry->piobase = uctxt->sc->base_addr;
 			   __entry->rcvhdrq_cnt = uctxt->rcvhdrq_cnt;
 			   __entry->rcvhdrq_phys = uctxt->rcvhdrq_phys;
 			   __entry->eager_cnt = uctxt->egrbufs.alloced;
diff --git a/drivers/infiniband/hw/hfi1/trace_tx.h b/drivers/infiniband/hw/hfi1/trace_tx.h
index 79c93ec..415d6be 100644
--- a/drivers/infiniband/hw/hfi1/trace_tx.h
+++ b/drivers/infiniband/hw/hfi1/trace_tx.h
@@ -369,22 +369,22 @@ TRACE_EVENT(hfi1_sdma_user_header,
 		    __field(u16, ctxt)
 		    __field(u8, subctxt)
 		    __field(u16, req)
-		    __field(__le32, pbc0)
-		    __field(__le32, pbc1)
-		    __field(__be32, lrh0)
-		    __field(__be32, lrh1)
-		    __field(__be32, bth0)
-		    __field(__be32, bth1)
-		    __field(__be32, bth2)
-		    __field(__le32, kdeth0)
-		    __field(__le32, kdeth1)
-		    __field(__le32, kdeth2)
-		    __field(__le32, kdeth3)
-		    __field(__le32, kdeth4)
-		    __field(__le32, kdeth5)
-		    __field(__le32, kdeth6)
-		    __field(__le32, kdeth7)
-		    __field(__le32, kdeth8)
+		    __field(u32, pbc0)
+		    __field(u32, pbc1)
+		    __field(u32, lrh0)
+		    __field(u32, lrh1)
+		    __field(u32, bth0)
+		    __field(u32, bth1)
+		    __field(u32, bth2)
+		    __field(u32, kdeth0)
+		    __field(u32, kdeth1)
+		    __field(u32, kdeth2)
+		    __field(u32, kdeth3)
+		    __field(u32, kdeth4)
+		    __field(u32, kdeth5)
+		    __field(u32, kdeth6)
+		    __field(u32, kdeth7)
+		    __field(u32, kdeth8)
 		    __field(u32, tidval)
 		    ),
 		    TP_fast_assign(
@@ -397,22 +397,22 @@ TRACE_EVENT(hfi1_sdma_user_header,
 		    __entry->ctxt = ctxt;
 		    __entry->subctxt = subctxt;
 		    __entry->req = req;
-		    __entry->pbc0 = pbc[0];
-		    __entry->pbc1 = pbc[1];
+		    __entry->pbc0 = le32_to_cpu(pbc[0]);
+		    __entry->pbc1 = le32_to_cpu(pbc[1]);
 		    __entry->lrh0 = be32_to_cpu(lrh[0]);
 		    __entry->lrh1 = be32_to_cpu(lrh[1]);
 		    __entry->bth0 = be32_to_cpu(bth[0]);
 		    __entry->bth1 = be32_to_cpu(bth[1]);
 		    __entry->bth2 = be32_to_cpu(bth[2]);
-		    __entry->kdeth0 = kdeth[0];
-		    __entry->kdeth1 = kdeth[1];
-		    __entry->kdeth2 = kdeth[2];
-		    __entry->kdeth3 = kdeth[3];
-		    __entry->kdeth4 = kdeth[4];
-		    __entry->kdeth5 = kdeth[5];
-		    __entry->kdeth6 = kdeth[6];
-		    __entry->kdeth7 = kdeth[7];
-		    __entry->kdeth8 = kdeth[8];
+		    __entry->kdeth0 = le32_to_cpu(kdeth[0]);
+		    __entry->kdeth1 = le32_to_cpu(kdeth[1]);
+		    __entry->kdeth2 = le32_to_cpu(kdeth[2]);
+		    __entry->kdeth3 = le32_to_cpu(kdeth[3]);
+		    __entry->kdeth4 = le32_to_cpu(kdeth[4]);
+		    __entry->kdeth5 = le32_to_cpu(kdeth[5]);
+		    __entry->kdeth6 = le32_to_cpu(kdeth[6]);
+		    __entry->kdeth7 = le32_to_cpu(kdeth[7]);
+		    __entry->kdeth8 = le32_to_cpu(kdeth[8]);
 		    __entry->tidval = tidval;
 	    ),
 	    TP_printk(USDMA_HDR_FORMAT,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
