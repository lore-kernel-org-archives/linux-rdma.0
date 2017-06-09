From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 05/10] IB/hfi1: Use a template for tid reg/unreg
Date: Fri, 09 Jun 2017 15:59:53 -0700
Message-ID: <20170609225951.26710.65032.stgit@scvm10.sc.intel.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609225424.26710.70167.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This is the preferred way to add a duplicate trace call.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/trace_rx.h |   46 +++++++++------------------------
 1 files changed, 13 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index 05fc6d6..7af5938 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -138,7 +138,8 @@
 		      )
 );
 
-TRACE_EVENT(hfi1_exp_tid_reg,
+DECLARE_EVENT_CLASS(
+	    hfi1_exp_tid_reg_unreg,
 	    TP_PROTO(unsigned int ctxt, u16 subctxt, u32 rarr,
 		     u32 npages, unsigned long va, unsigned long pa,
 		     dma_addr_t dma),
@@ -172,38 +173,17 @@
 		      )
 	);
 
-TRACE_EVENT(hfi1_exp_tid_unreg,
-	    TP_PROTO(unsigned int ctxt, u16 subctxt, u32 rarr, u32 npages,
-		     unsigned long va, unsigned long pa, dma_addr_t dma),
-	    TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma),
-	    TP_STRUCT__entry(
-			     __field(unsigned int, ctxt)
-			     __field(u16, subctxt)
-			     __field(u32, rarr)
-			     __field(u32, npages)
-			     __field(unsigned long, va)
-			     __field(unsigned long, pa)
-			     __field(dma_addr_t, dma)
-			     ),
-	    TP_fast_assign(
-			   __entry->ctxt = ctxt;
-			   __entry->subctxt = subctxt;
-			   __entry->rarr = rarr;
-			   __entry->npages = npages;
-			   __entry->va = va;
-			   __entry->pa = pa;
-			   __entry->dma = dma;
-			   ),
-	    TP_printk("[%u:%u] entry:%u, %u pages @ 0x%lx, va:0x%lx dma:0x%llx",
-		      __entry->ctxt,
-		      __entry->subctxt,
-		      __entry->rarr,
-		      __entry->npages,
-		      __entry->pa,
-		      __entry->va,
-		      __entry->dma
-		      )
-	);
+DEFINE_EVENT(
+	hfi1_exp_tid_reg_unreg, hfi1_exp_tid_unreg,
+	TP_PROTO(unsigned int ctxt, u16 subctxt, u32 rarr, u32 npages,
+		 unsigned long va, unsigned long pa, dma_addr_t dma),
+	TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma));
+
+DEFINE_EVENT(
+	hfi1_exp_tid_reg_unreg, hfi1_exp_tid_reg,
+	TP_PROTO(unsigned int ctxt, u16 subctxt, u32 rarr, u32 npages,
+		 unsigned long va, unsigned long pa, dma_addr_t dma),
+	TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma));
 
 TRACE_EVENT(hfi1_exp_tid_inval,
 	    TP_PROTO(unsigned int ctxt, u16 subctxt, unsigned long va, u32 rarr,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
