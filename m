From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 5/6] staging/rdma/hfi1: adding per SDMA engine stats to hfistats
Date: Mon, 21 Dec 2015 21:56:18 -0500
Message-ID: <1450752979-29650-6-git-send-email-jubin.john@intel.com>
References: <1450752979-29650-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450752979-29650-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Added the following per sdma engine stats:
  - SendDmaDescFetchedCnt
  - software maintained count of SDMA interrupts
	 (SDmaInt, SDmaIdleInt, SDmaProgressInt)
  - software maintained counts of SDMA error cases

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes in v2:
	- None

Changes in v3:
	- Refreshed patch against latest staging-testing

 drivers/staging/rdma/hfi1/chip.c           |  110 +++++++++++++++++++++++++++-
 drivers/staging/rdma/hfi1/chip.h           |    5 +
 drivers/staging/rdma/hfi1/chip_registers.h |    1 +
 drivers/staging/rdma/hfi1/hfi.h            |    1 +
 drivers/staging/rdma/hfi1/sdma.c           |    9 ++-
 drivers/staging/rdma/hfi1/sdma.h           |    7 ++
 6 files changed, 129 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 503bfca..f4f720d 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1297,10 +1297,58 @@ static u64 dev_access_u32_csr(const struct cntr_entry *entry,
 			    void *context, int vl, int mode, u64 data)
 {
 	struct hfi1_devdata *dd = context;
+	u64 csr = entry->csr;
 
-	if (vl != CNTR_INVALID_VL)
-		return 0;
-	return read_write_csr(dd, entry->csr, mode, data);
+	if (entry->flags & CNTR_SDMA) {
+		if (vl == CNTR_INVALID_VL)
+			return 0;
+		csr += 0x100 * vl;
+	} else {
+		if (vl != CNTR_INVALID_VL)
+			return 0;
+	}
+	return read_write_csr(dd, csr, mode, data);
+}
+
+static u64 access_sde_err_cnt(const struct cntr_entry *entry,
+			      void *context, int idx, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	if (dd->per_sdma && idx < dd->num_sdma)
+		return dd->per_sdma[idx].err_cnt;
+	return 0;
+}
+
+static u64 access_sde_int_cnt(const struct cntr_entry *entry,
+			      void *context, int idx, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	if (dd->per_sdma && idx < dd->num_sdma)
+		return dd->per_sdma[idx].sdma_int_cnt;
+	return 0;
+}
+
+static u64 access_sde_idle_int_cnt(const struct cntr_entry *entry,
+				   void *context, int idx, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	if (dd->per_sdma && idx < dd->num_sdma)
+		return dd->per_sdma[idx].idle_int_cnt;
+	return 0;
+}
+
+static u64 access_sde_progress_int_cnt(const struct cntr_entry *entry,
+				       void *context, int idx, int mode,
+				       u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	if (dd->per_sdma && idx < dd->num_sdma)
+		return dd->per_sdma[idx].progress_int_cnt;
+	return 0;
 }
 
 static u64 dev_access_u64_csr(const struct cntr_entry *entry, void *context,
@@ -4070,6 +4118,22 @@ static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 			    access_sw_kmem_wait),
 [C_SW_SEND_SCHED] = CNTR_ELEM("SendSched", 0, 0, CNTR_NORMAL,
 			    access_sw_send_schedule),
+[C_SDMA_DESC_FETCHED_CNT] = CNTR_ELEM("SDEDscFdCn",
+				      SEND_DMA_DESC_FETCHED_CNT, 0,
+				      CNTR_NORMAL | CNTR_32BIT | CNTR_SDMA,
+				      dev_access_u32_csr),
+[C_SDMA_INT_CNT] = CNTR_ELEM("SDMAInt", 0, 0,
+			     CNTR_NORMAL | CNTR_32BIT | CNTR_SDMA,
+			     access_sde_int_cnt),
+[C_SDMA_ERR_CNT] = CNTR_ELEM("SDMAErrCt", 0, 0,
+			     CNTR_NORMAL | CNTR_32BIT | CNTR_SDMA,
+			     access_sde_err_cnt),
+[C_SDMA_IDLE_INT_CNT] = CNTR_ELEM("SDMAIdInt", 0, 0,
+				  CNTR_NORMAL | CNTR_32BIT | CNTR_SDMA,
+				  access_sde_idle_int_cnt),
+[C_SDMA_PROGRESS_INT_CNT] = CNTR_ELEM("SDMAPrIntCn", 0, 0,
+				      CNTR_NORMAL | CNTR_32BIT | CNTR_SDMA,
+				      access_sde_progress_int_cnt),
 /* MISC_ERR_STATUS */
 [C_MISC_PLL_LOCK_FAIL_ERR] = CNTR_ELEM("MISC_PLL_LOCK_FAIL_ERR", 0, 0,
 				CNTR_NORMAL,
@@ -5707,6 +5771,7 @@ static void handle_sdma_eng_err(struct hfi1_devdata *dd,
 	dd_dev_err(sde->dd, "CONFIG SDMA(%u) source: %u status 0x%llx\n",
 		   sde->this_idx, source, (unsigned long long)status);
 #endif
+	sde->err_cnt++;
 	sdma_engine_error(sde, status);
 
 	/*
@@ -11150,6 +11215,20 @@ u32 hfi1_read_cntrs(struct hfi1_devdata *dd, loff_t pos, char **namep,
 						dd->cntrs[entry->offset + j] =
 									    val;
 					}
+				} else if (entry->flags & CNTR_SDMA) {
+					hfi1_cdbg(CNTR,
+						  "\t Per SDMA Engine\n");
+					for (j = 0; j < dd->chip_sdma_engines;
+					     j++) {
+						val =
+						entry->rw_cntr(entry, dd, j,
+							       CNTR_MODE_R, 0);
+						hfi1_cdbg(CNTR,
+							  "\t\tRead 0x%llx for %d\n",
+							  val, j);
+						dd->cntrs[entry->offset + j] =
+									val;
+					}
 				} else {
 					val = entry->rw_cntr(entry, dd,
 							CNTR_INVALID_VL,
@@ -11553,6 +11632,21 @@ static int init_cntrs(struct hfi1_devdata *dd)
 				dd->ndevcntrs++;
 				index++;
 			}
+		} else if (dev_cntrs[i].flags & CNTR_SDMA) {
+			hfi1_dbg_early(
+				       "\tProcessing per SDE counters chip enginers %u\n",
+				       dd->chip_sdma_engines);
+			dev_cntrs[i].offset = index;
+			for (j = 0; j < dd->chip_sdma_engines; j++) {
+				memset(name, '\0', C_MAX_NAME);
+				snprintf(name, C_MAX_NAME, "%s%d",
+					 dev_cntrs[i].name, j);
+				sz += strlen(name);
+				sz++;
+				hfi1_dbg_early("\t\t%s\n", name);
+				dd->ndevcntrs++;
+				index++;
+			}
 		} else {
 			/* +1 for newline  */
 			sz += strlen(dev_cntrs[i].name) + 1;
@@ -11594,6 +11688,16 @@ static int init_cntrs(struct hfi1_devdata *dd)
 					p += strlen(name);
 					*p++ = '\n';
 				}
+			} else if (dev_cntrs[i].flags & CNTR_SDMA) {
+				for (j = 0; j < TXE_NUM_SDMA_ENGINES;
+				     j++) {
+					memset(name, '\0', C_MAX_NAME);
+					snprintf(name, C_MAX_NAME, "%s%d",
+						 dev_cntrs[i].name, j);
+					memcpy(p, name, strlen(name));
+					p += strlen(name);
+					*p++ = '\n';
+				}
 			} else {
 				memcpy(p, dev_cntrs[i].name,
 				       strlen(dev_cntrs[i].name));
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 1368a44..b46ef66 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -787,6 +787,11 @@ enum {
 	C_SW_PIO_WAIT,
 	C_SW_KMEM_WAIT,
 	C_SW_SEND_SCHED,
+	C_SDMA_DESC_FETCHED_CNT,
+	C_SDMA_INT_CNT,
+	C_SDMA_ERR_CNT,
+	C_SDMA_IDLE_INT_CNT,
+	C_SDMA_PROGRESS_INT_CNT,
 /* MISC_ERR_STATUS */
 	C_MISC_PLL_LOCK_FAIL_ERR,
 	C_MISC_MBIST_FAIL_ERR,
diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/staging/rdma/hfi1/chip_registers.h
index 701e9e1..fb36541 100644
--- a/drivers/staging/rdma/hfi1/chip_registers.h
+++ b/drivers/staging/rdma/hfi1/chip_registers.h
@@ -1290,5 +1290,6 @@
 #define CCE_INT_BLOCKED (CCE + 0x000000110C00)
 #define SEND_DMA_IDLE_CNT (TXE + 0x000000200040)
 #define SEND_DMA_DESC_FETCHED_CNT (TXE + 0x000000200058)
+#define CCE_MSIX_PBA_OFFSET 0X0110000
 
 #endif          /* DEF_CHIP_REG */
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index d4a859f..d32ee84 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -490,6 +490,7 @@ struct hfi1_sge_state;
 #define CNTR_DISABLED		0x2 /* Disable this counter */
 #define CNTR_32BIT		0x4 /* Simulate 64 bits for this counter */
 #define CNTR_VL			0x8 /* Per VL counter */
+#define CNTR_SDMA              0x10
 #define CNTR_INVALID_VL		-1  /* Specifies invalid VL */
 #define CNTR_MODE_W		0x0
 #define CNTR_MODE_R		0x1
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 1d38be5..cb66bd0 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1061,7 +1061,6 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		sde->desc_avail = sdma_descq_freecnt(sde);
 		sde->sdma_shift = ilog2(descq_cnt);
 		sde->sdma_mask = (1 << sde->sdma_shift) - 1;
-		sde->descq_full_count = 0;
 
 		/* Create a mask for all 3 chip interrupt sources */
 		sde->imask = (u64)1 << (0*TXE_NUM_SDMA_ENGINES + this_idx)
@@ -1073,6 +1072,8 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		/* Create a mask specifically for sdma_progress */
 		sde->progress_mask =
 			(u64)1 << (TXE_NUM_SDMA_ENGINES + this_idx);
+		sde->int_mask =
+			(u64)1 << (0 * TXE_NUM_SDMA_ENGINES + this_idx);
 		spin_lock_init(&sde->tail_lock);
 		seqlock_init(&sde->head_lock);
 		spin_lock_init(&sde->senddmactrl_lock);
@@ -1552,6 +1553,12 @@ void sdma_engine_interrupt(struct sdma_engine *sde, u64 status)
 	trace_hfi1_sdma_engine_interrupt(sde, status);
 	write_seqlock(&sde->head_lock);
 	sdma_set_desc_cnt(sde, sdma_desct_intr);
+	if (status & sde->idle_mask)
+		sde->idle_int_cnt++;
+	else if (status & sde->progress_mask)
+		sde->progress_int_cnt++;
+	else if (status & sde->int_mask)
+		sde->sdma_int_cnt++;
 	sdma_make_progress(sde, status);
 	write_sequnlock(&sde->head_lock);
 }
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index da89e64..757017a 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -409,6 +409,7 @@ struct sdma_engine {
 	u64 imask;			/* clear interrupt mask */
 	u64 idle_mask;
 	u64 progress_mask;
+	u64 int_mask;
 	/* private: */
 	volatile __le64      *head_dma; /* DMA'ed by chip */
 	/* private: */
@@ -465,6 +466,12 @@ struct sdma_engine {
 	u16                   tx_head;
 	/* private: */
 	u64                   last_status;
+	/* private */
+	u64                     err_cnt;
+	/* private */
+	u64                     sdma_int_cnt;
+	u64                     idle_int_cnt;
+	u64                     progress_int_cnt;
 
 	/* private: */
 	struct list_head      dmawait;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
