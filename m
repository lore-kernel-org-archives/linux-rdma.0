From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 06/10] IB/hfi1: Add traces for TID operations
Date: Fri, 09 Jun 2017 15:59:59 -0700
Message-ID: <20170609225958.26710.56627.stgit@scvm10.sc.intel.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609225424.26710.70167.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds a trace for putting a TID and
for writing the RcvArray CSR.

The CSR access template can be easily extended for additional
CSR readq/writeq calls.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c       |   16 ++------------
 drivers/infiniband/hw/hfi1/trace_misc.h |   20 ++++++++++++++++++
 drivers/infiniband/hw/hfi1/trace_rx.h   |   35 +++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 358559c..61cc567 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9745,17 +9745,6 @@ static inline int init_cpu_counters(struct hfi1_devdata *dd)
 	return 0;
 }
 
-static const char * const pt_names[] = {
-	"expected",
-	"eager",
-	"invalid"
-};
-
-static const char *pt_name(u32 type)
-{
-	return type >= ARRAY_SIZE(pt_names) ? "unknown" : pt_names[type];
-}
-
 /*
  * index is the index into the receive array
  */
@@ -9777,15 +9766,14 @@ void hfi1_put_tid(struct hfi1_devdata *dd, u32 index,
 			   type, index);
 		goto done;
 	}
-
-	hfi1_cdbg(TID, "type %s, index 0x%x, pa 0x%lx, bsize 0x%lx",
-		  pt_name(type), index, pa, (unsigned long)order);
+	trace_hfi1_put_tid(dd, index, type, pa, order);
 
 #define RT_ADDR_SHIFT 12	/* 4KB kernel address boundary */
 	reg = RCV_ARRAY_RT_WRITE_ENABLE_SMASK
 		| (u64)order << RCV_ARRAY_RT_BUF_SIZE_SHIFT
 		| ((pa >> RT_ADDR_SHIFT) & RCV_ARRAY_RT_ADDR_MASK)
 					<< RCV_ARRAY_RT_ADDR_SHIFT;
+	trace_hfi1_write_rcvarray(base + (index * 8), reg);
 	writeq(reg, base + (index * 8));
 
 	if (type == PT_EAGER)
diff --git a/drivers/infiniband/hw/hfi1/trace_misc.h b/drivers/infiniband/hw/hfi1/trace_misc.h
index deac77d..8db2253 100644
--- a/drivers/infiniband/hw/hfi1/trace_misc.h
+++ b/drivers/infiniband/hw/hfi1/trace_misc.h
@@ -72,6 +72,26 @@
 		      __entry->src)
 );
 
+DECLARE_EVENT_CLASS(
+	hfi1_csr_template,
+	TP_PROTO(void __iomem *addr, u64 value),
+	TP_ARGS(addr, value),
+	TP_STRUCT__entry(
+		__field(void __iomem *, addr)
+		__field(u64, value)
+	),
+	TP_fast_assign(
+		__entry->addr = addr;
+		__entry->value = value;
+	),
+	TP_printk("addr %p value %llx", __entry->addr, __entry->value)
+);
+
+DEFINE_EVENT(
+	hfi1_csr_template, hfi1_write_rcvarray,
+	TP_PROTO(void __iomem *addr, u64 value),
+	TP_ARGS(addr, value));
+
 #ifdef CONFIG_FAULT_INJECTION
 TRACE_EVENT(hfi1_fault_opcode,
 	    TP_PROTO(struct rvt_qp *qp, u8 opcode),
diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index 7af5938..8492957 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -52,6 +52,13 @@
 
 #include "hfi.h"
 
+#define tidtype_name(type) { PT_##type, #type }
+#define show_tidtype(type)                   \
+__print_symbolic(type,                       \
+	tidtype_name(EXPECTED),              \
+	tidtype_name(EAGER),                 \
+	tidtype_name(INVALID))               \
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM hfi1_rx
 
@@ -185,6 +192,34 @@
 		 unsigned long va, unsigned long pa, dma_addr_t dma),
 	TP_ARGS(ctxt, subctxt, rarr, npages, va, pa, dma));
 
+TRACE_EVENT(
+	hfi1_put_tid,
+	TP_PROTO(struct hfi1_devdata *dd,
+		 u32 index, u32 type, unsigned long pa, u16 order),
+	TP_ARGS(dd, index, type, pa, order),
+	TP_STRUCT__entry(
+		DD_DEV_ENTRY(dd)
+		__field(unsigned long, pa);
+		__field(u32, index);
+		__field(u32, type);
+		__field(u16, order);
+	),
+	TP_fast_assign(
+		DD_DEV_ASSIGN(dd);
+		__entry->pa = pa;
+		__entry->index = index;
+		__entry->type = type;
+		__entry->order = order;
+	),
+	TP_printk("[%s] type %s pa %lx index %u order %u",
+		  __get_str(dev),
+		  show_tidtype(__entry->type),
+		  __entry->pa,
+		  __entry->index,
+		  __entry->order
+	)
+);
+
 TRACE_EVENT(hfi1_exp_tid_inval,
 	    TP_PROTO(unsigned int ctxt, u16 subctxt, unsigned long va, u32 rarr,
 		     u32 npages, dma_addr_t dma),

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
