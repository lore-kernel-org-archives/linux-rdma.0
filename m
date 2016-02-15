From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 01/21] staging/rdma/hfi1: Add spaces around binary operators
Date: Sun, 14 Feb 2016 20:19:24 -0800
Message-ID: <20160215041918.351.99367.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add spaces around binary operators.

Fixes checkpatch check:
CHECK: spaces preferred around that 'x'
where x is a binary operator

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c      |  104 +++++++++++++++++----------------
 drivers/staging/rdma/hfi1/debugfs.c   |    2 -
 drivers/staging/rdma/hfi1/driver.c    |    2 -
 drivers/staging/rdma/hfi1/eprom.c     |   10 ++-
 drivers/staging/rdma/hfi1/firmware.c  |   28 ++++-----
 drivers/staging/rdma/hfi1/hfi.h       |    2 -
 drivers/staging/rdma/hfi1/intr.c      |    2 -
 drivers/staging/rdma/hfi1/mad.c       |   22 +++----
 drivers/staging/rdma/hfi1/mad.h       |    2 -
 drivers/staging/rdma/hfi1/pcie.c      |    2 -
 drivers/staging/rdma/hfi1/pio.c       |    4 +
 drivers/staging/rdma/hfi1/pio_copy.c  |   18 +++---
 drivers/staging/rdma/hfi1/qsfp.c      |    6 +-
 drivers/staging/rdma/hfi1/qsfp.h      |    2 -
 drivers/staging/rdma/hfi1/rc.c        |    2 -
 drivers/staging/rdma/hfi1/sdma.c      |   16 +++--
 drivers/staging/rdma/hfi1/sdma.h      |    2 -
 drivers/staging/rdma/hfi1/user_sdma.c |    2 -
 drivers/staging/rdma/hfi1/verbs.c     |    2 -
 19 files changed, 115 insertions(+), 115 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index b169e89..79c215e 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -422,10 +422,10 @@ static struct flag_table pio_err_status_flags[] = {
 	SEC_SPC_FREEZE,
 	SEND_PIO_ERR_STATUS_PIO_STATE_MACHINE_ERR_SMASK),
 /*23*/	FLAG_ENTRY("PioWriteQwValidParity",
-	SEC_WRITE_DROPPED|SEC_SPC_FREEZE,
+	SEC_WRITE_DROPPED | SEC_SPC_FREEZE,
 	SEND_PIO_ERR_STATUS_PIO_WRITE_QW_VALID_PARITY_ERR_SMASK),
 /*24*/	FLAG_ENTRY("PioBlockQwCountParity",
-	SEC_WRITE_DROPPED|SEC_SPC_FREEZE,
+	SEC_WRITE_DROPPED | SEC_SPC_FREEZE,
 	SEND_PIO_ERR_STATUS_PIO_BLOCK_QW_COUNT_PARITY_ERR_SMASK),
 /*25*/	FLAG_ENTRY("PioVlfVlLenParity",
 	SEC_SPC_FREEZE,
@@ -1196,7 +1196,7 @@ CNTR_ELEM(#name, \
 #define OVR_LBL(ctx) C_RCV_HDR_OVF_ ## ctx
 #define OVR_ELM(ctx) \
 CNTR_ELEM("RcvHdrOvr" #ctx, \
-	  (RCV_HDR_OVFL_CNT + ctx*0x100), \
+	  (RCV_HDR_OVFL_CNT + ctx * 0x100), \
 	  0, CNTR_NORMAL, port_access_u64_csr)
 
 /* 32bit TXE */
@@ -5259,7 +5259,7 @@ static char *is_various_name(char *buf, size_t bsize, unsigned int source)
 	if (source < ARRAY_SIZE(various_names))
 		strncpy(buf, various_names[source], bsize);
 	else
-		snprintf(buf, bsize, "Reserved%u", source+IS_VARIOUS_START);
+		snprintf(buf, bsize, "Reserved%u", source + IS_VARIOUS_START);
 	return buf;
 }
 
@@ -6318,7 +6318,7 @@ void reset_link_credits(struct hfi1_devdata *dd)
 
 	/* remove all previous VL credit limits */
 	for (i = 0; i < TXE_NUM_DATA_VL; i++)
-		write_csr(dd, SEND_CM_CREDIT_VL + (8*i), 0);
+		write_csr(dd, SEND_CM_CREDIT_VL + (8 * i), 0);
 	write_csr(dd, SEND_CM_CREDIT_VL15, 0);
 	write_global_credit(dd, 0, 0, 0);
 	/* reset the CM block */
@@ -7573,7 +7573,7 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		/* if the link is already going down or disabled, do not
 		 * queue another */
 		if ((ppd->host_link_state
-				    & (HLS_GOING_OFFLINE|HLS_LINK_COOLDOWN))
+				    & (HLS_GOING_OFFLINE | HLS_LINK_COOLDOWN))
 				|| ppd->link_enabled == 0) {
 			dd_dev_info(dd, "%s: not queuing link down\n",
 				__func__);
@@ -7991,7 +7991,7 @@ static irqreturn_t general_interrupt(int irq, void *data)
 
 	/* phase 2: call the appropriate handler */
 	for_each_set_bit(bit, (unsigned long *)&regs[0],
-						CCE_NUM_INT_CSRS*64) {
+						CCE_NUM_INT_CSRS * 64) {
 		is_interrupt(dd, bit);
 	}
 
@@ -8014,12 +8014,12 @@ static irqreturn_t sdma_interrupt(int irq, void *data)
 
 	/* This read_csr is really bad in the hot path */
 	status = read_csr(dd,
-			CCE_INT_STATUS + (8*(IS_SDMA_START/64)))
+			CCE_INT_STATUS + (8 * (IS_SDMA_START / 64)))
 			& sde->imask;
 	if (likely(status)) {
 		/* clear the interrupt(s) */
 		write_csr(dd,
-			CCE_INT_CLEAR + (8*(IS_SDMA_START/64)),
+			CCE_INT_CLEAR + (8 * (IS_SDMA_START / 64)),
 			status);
 
 		/* handle the interrupt(s) */
@@ -8944,10 +8944,10 @@ static u16 opa_to_vc_link_widths(u16 opa_widths)
 		u16 from;
 		u16 to;
 	} opa_link_xlate[] = {
-		{ OPA_LINK_WIDTH_1X, 1 << (1-1)  },
-		{ OPA_LINK_WIDTH_2X, 1 << (2-1)  },
-		{ OPA_LINK_WIDTH_3X, 1 << (3-1)  },
-		{ OPA_LINK_WIDTH_4X, 1 << (4-1)  },
+		{ OPA_LINK_WIDTH_1X, 1 << (1 - 1)  },
+		{ OPA_LINK_WIDTH_2X, 1 << (2 - 1)  },
+		{ OPA_LINK_WIDTH_3X, 1 << (3 - 1)  },
+		{ OPA_LINK_WIDTH_4X, 1 << (4 - 1)  },
 	};
 
 	for (i = 0; i < ARRAY_SIZE(opa_link_xlate); i++) {
@@ -9725,7 +9725,7 @@ static void set_lidlmc(struct hfi1_pportdata *ppd)
 	c1 &= ~(DCC_CFG_PORT_CONFIG1_TARGET_DLID_SMASK
 		| DCC_CFG_PORT_CONFIG1_DLID_MASK_SMASK);
 	c1 |= ((ppd->lid & DCC_CFG_PORT_CONFIG1_TARGET_DLID_MASK)
-			<< DCC_CFG_PORT_CONFIG1_TARGET_DLID_SHIFT)|
+			<< DCC_CFG_PORT_CONFIG1_TARGET_DLID_SHIFT) |
 	      ((mask & DCC_CFG_PORT_CONFIG1_DLID_MASK_MASK)
 			<< DCC_CFG_PORT_CONFIG1_DLID_MASK_SHIFT);
 	write_csr(ppd->dd, DCC_CFG_PORT_CONFIG1, c1);
@@ -10290,7 +10290,7 @@ int hfi1_set_ib_cfg(struct hfi1_pportdata *ppd, int which, u32 val)
 		 * The VL Arbitrator high limit is sent in units of 4k
 		 * bytes, while HFI stores it in units of 64 bytes.
 		 */
-		val *= 4096/64;
+		val *= 4096 / 64;
 		reg = ((u64)val & SEND_HIGH_PRIORITY_LIMIT_LIMIT_MASK)
 			<< SEND_HIGH_PRIORITY_LIMIT_LIMIT_SHIFT;
 		write_csr(ppd->dd, SEND_HIGH_PRIORITY_LIMIT, reg);
@@ -10507,7 +10507,7 @@ static int get_buffer_control(struct hfi1_devdata *dd,
 
 	/* OPA and HFI have a 1-1 mapping */
 	for (i = 0; i < TXE_NUM_DATA_VL; i++)
-		read_one_cm_vl(dd, SEND_CM_CREDIT_VL + (8*i), &bc->vl[i]);
+		read_one_cm_vl(dd, SEND_CM_CREDIT_VL + (8 * i), &bc->vl[i]);
 
 	/* NOTE: assumes that VL* and VL15 CSRs are bit-wise identical */
 	read_one_cm_vl(dd, SEND_CM_CREDIT_VL15, &bc->vl[15]);
@@ -11207,16 +11207,16 @@ u32 hdrqempty(struct hfi1_ctxtdata *rcd)
 static u32 encoded_size(u32 size)
 {
 	switch (size) {
-	case   4*1024: return 0x1;
-	case   8*1024: return 0x2;
-	case  16*1024: return 0x3;
-	case  32*1024: return 0x4;
-	case  64*1024: return 0x5;
-	case 128*1024: return 0x6;
-	case 256*1024: return 0x7;
-	case 512*1024: return 0x8;
-	case   1*1024*1024: return 0x9;
-	case   2*1024*1024: return 0xa;
+	case   4 * 1024: return 0x1;
+	case   8 * 1024: return 0x2;
+	case  16 * 1024: return 0x3;
+	case  32 * 1024: return 0x4;
+	case  64 * 1024: return 0x5;
+	case 128 * 1024: return 0x6;
+	case 256 * 1024: return 0x7;
+	case 512 * 1024: return 0x8;
+	case   1 * 1024 * 1024: return 0x9;
+	case   2 * 1024 * 1024: return 0xa;
 	}
 	return 0x1;	/* if invalid, go with the minimum size */
 }
@@ -12324,12 +12324,12 @@ void set_intr_state(struct hfi1_devdata *dd, u32 enable)
 	if (enable) {
 		/* enable all interrupts */
 		for (i = 0; i < CCE_NUM_INT_CSRS; i++)
-			write_csr(dd, CCE_INT_MASK + (8*i), ~(u64)0);
+			write_csr(dd, CCE_INT_MASK + (8 * i), ~(u64)0);
 
 		init_qsfp_int(dd);
 	} else {
 		for (i = 0; i < CCE_NUM_INT_CSRS; i++)
-			write_csr(dd, CCE_INT_MASK + (8*i), 0ull);
+			write_csr(dd, CCE_INT_MASK + (8 * i), 0ull);
 	}
 }
 
@@ -12341,7 +12341,7 @@ static void clear_all_interrupts(struct hfi1_devdata *dd)
 	int i;
 
 	for (i = 0; i < CCE_NUM_INT_CSRS; i++)
-		write_csr(dd, CCE_INT_CLEAR + (8*i), ~(u64)0);
+		write_csr(dd, CCE_INT_CLEAR + (8 * i), ~(u64)0);
 
 	write_csr(dd, CCE_ERR_CLEAR, ~(u64)0);
 	write_csr(dd, MISC_ERR_CLEAR, ~(u64)0);
@@ -12421,10 +12421,10 @@ static void remap_intr(struct hfi1_devdata *dd, int isrc, int msix_intr)
 	/* direct the chip source to the given MSI-X interrupt */
 	m = isrc / 8;
 	n = isrc % 8;
-	reg = read_csr(dd, CCE_INT_MAP + (8*m));
-	reg &= ~((u64)0xff << (8*n));
-	reg |= ((u64)msix_intr & 0xff) << (8*n);
-	write_csr(dd, CCE_INT_MAP + (8*m), reg);
+	reg = read_csr(dd, CCE_INT_MAP + (8 * m));
+	reg &= ~((u64)0xff << (8 * n));
+	reg |= ((u64)msix_intr & 0xff) << (8 * n);
+	write_csr(dd, CCE_INT_MAP + (8 * m), reg);
 }
 
 static void remap_sdma_interrupts(struct hfi1_devdata *dd,
@@ -12437,11 +12437,11 @@ static void remap_sdma_interrupts(struct hfi1_devdata *dd,
 	 *	SDMAProgress
 	 *	SDMAIdle
 	 */
-	remap_intr(dd, IS_SDMA_START + 0*TXE_NUM_SDMA_ENGINES + engine,
+	remap_intr(dd, IS_SDMA_START + 0 * TXE_NUM_SDMA_ENGINES + engine,
 		msix_intr);
-	remap_intr(dd, IS_SDMA_START + 1*TXE_NUM_SDMA_ENGINES + engine,
+	remap_intr(dd, IS_SDMA_START + 1 * TXE_NUM_SDMA_ENGINES + engine,
 		msix_intr);
-	remap_intr(dd, IS_SDMA_START + 2*TXE_NUM_SDMA_ENGINES + engine,
+	remap_intr(dd, IS_SDMA_START + 2 * TXE_NUM_SDMA_ENGINES + engine,
 		msix_intr);
 }
 
@@ -12520,9 +12520,9 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 			 * Set the interrupt register and mask for this
 			 * context's interrupt.
 			 */
-			rcd->ireg = (IS_RCVAVAIL_START+idx) / 64;
+			rcd->ireg = (IS_RCVAVAIL_START + idx) / 64;
 			rcd->imask = ((u64)1) <<
-					((IS_RCVAVAIL_START+idx) % 64);
+					((IS_RCVAVAIL_START + idx) % 64);
 			handler = receive_context_interrupt;
 			thread = receive_context_thread;
 			arg = rcd;
@@ -12542,7 +12542,7 @@ static int request_msix_irqs(struct hfi1_devdata *dd)
 		if (arg == NULL)
 			continue;
 		/* make sure the name is terminated */
-		me->name[sizeof(me->name)-1] = 0;
+		me->name[sizeof(me->name) - 1] = 0;
 
 		ret = request_threaded_irq(me->msix.vector, handler, thread, 0,
 						me->name, arg);
@@ -12581,7 +12581,7 @@ static void reset_interrupts(struct hfi1_devdata *dd)
 
 	/* all chip interrupts map to MSI-X 0 */
 	for (i = 0; i < CCE_NUM_INT_MAP_CSRS; i++)
-		write_csr(dd, CCE_INT_MAP + (8*i), 0);
+		write_csr(dd, CCE_INT_MAP + (8 * i), 0);
 }
 
 static int set_up_interrupts(struct hfi1_devdata *dd)
@@ -12831,7 +12831,7 @@ static void write_uninitialized_csrs_and_memories(struct hfi1_devdata *dd)
 
 	/* CceIntMap */
 	for (i = 0; i < CCE_NUM_INT_MAP_CSRS; i++)
-		write_csr(dd, CCE_INT_MAP+(8*i), 0);
+		write_csr(dd, CCE_INT_MAP + (8 * i), 0);
 
 	/* SendCtxtCreditReturnAddr */
 	for (i = 0; i < dd->chip_send_contexts; i++)
@@ -12849,12 +12849,12 @@ static void write_uninitialized_csrs_and_memories(struct hfi1_devdata *dd)
 		write_kctxt_csr(dd, i, RCV_HDR_ADDR, 0);
 		write_kctxt_csr(dd, i, RCV_HDR_TAIL_ADDR, 0);
 		for (j = 0; j < RXE_NUM_TID_FLOWS; j++)
-			write_uctxt_csr(dd, i, RCV_TID_FLOW_TABLE+(8*j), 0);
+			write_uctxt_csr(dd, i, RCV_TID_FLOW_TABLE + (8 * j), 0);
 	}
 
 	/* RcvArray */
 	for (i = 0; i < dd->chip_rcv_array_count; i++)
-		write_csr(dd, RCV_ARRAY + (8*i),
+		write_csr(dd, RCV_ARRAY + (8 * i),
 					RCV_ARRAY_RT_WRITE_ENABLE_SMASK);
 
 	/* RcvQPMapTable */
@@ -13092,15 +13092,15 @@ static void reset_txe_csrs(struct hfi1_devdata *dd)
 	write_csr(dd, SEND_ERR_CLEAR, ~0ull);
 	/* SEND_ERR_FORCE read-only */
 	for (i = 0; i < VL_ARB_LOW_PRIO_TABLE_SIZE; i++)
-		write_csr(dd, SEND_LOW_PRIORITY_LIST + (8*i), 0);
+		write_csr(dd, SEND_LOW_PRIORITY_LIST + (8 * i), 0);
 	for (i = 0; i < VL_ARB_HIGH_PRIO_TABLE_SIZE; i++)
-		write_csr(dd, SEND_HIGH_PRIORITY_LIST + (8*i), 0);
-	for (i = 0; i < dd->chip_send_contexts/NUM_CONTEXTS_PER_SET; i++)
-		write_csr(dd, SEND_CONTEXT_SET_CTRL + (8*i), 0);
+		write_csr(dd, SEND_HIGH_PRIORITY_LIST + (8 * i), 0);
+	for (i = 0; i < dd->chip_send_contexts / NUM_CONTEXTS_PER_SET; i++)
+		write_csr(dd, SEND_CONTEXT_SET_CTRL + (8 * i), 0);
 	for (i = 0; i < TXE_NUM_32_BIT_COUNTER; i++)
-		write_csr(dd, SEND_COUNTER_ARRAY32 + (8*i), 0);
+		write_csr(dd, SEND_COUNTER_ARRAY32 + (8 * i), 0);
 	for (i = 0; i < TXE_NUM_64_BIT_COUNTER; i++)
-		write_csr(dd, SEND_COUNTER_ARRAY64 + (8*i), 0);
+		write_csr(dd, SEND_COUNTER_ARRAY64 + (8 * i), 0);
 	write_csr(dd, SEND_CM_CTRL, SEND_CM_CTRL_RESETCSR);
 	write_csr(dd, SEND_CM_GLOBAL_CREDIT,
 					SEND_CM_GLOBAL_CREDIT_RESETCSR);
@@ -13111,7 +13111,7 @@ static void reset_txe_csrs(struct hfi1_devdata *dd)
 	write_csr(dd, SEND_CM_REMOTE_AU_TABLE0_TO3, 0);
 	write_csr(dd, SEND_CM_REMOTE_AU_TABLE4_TO7, 0);
 	for (i = 0; i < TXE_NUM_DATA_VL; i++)
-		write_csr(dd, SEND_CM_CREDIT_VL + (8*i), 0);
+		write_csr(dd, SEND_CM_CREDIT_VL + (8 * i), 0);
 	write_csr(dd, SEND_CM_CREDIT_VL15, 0);
 	/* SEND_CM_CREDIT_USED_VL read-only */
 	/* SEND_CM_CREDIT_USED_VL15 read-only */
@@ -13403,7 +13403,7 @@ static void init_chip(struct hfi1_devdata *dd)
 		write_csr(dd, RCV_CTXT_CTRL, 0);
 	/* mask all interrupt sources */
 	for (i = 0; i < CCE_NUM_INT_CSRS; i++)
-		write_csr(dd, CCE_INT_MASK + (8*i), 0ull);
+		write_csr(dd, CCE_INT_MASK + (8 * i), 0ull);
 
 	/*
 	 * DC Reset: do a full DC reset before the register clear.
@@ -14404,7 +14404,7 @@ static void handle_temp_err(struct hfi1_devdata *dd)
 	dd_dev_emerg(dd,
 		     "Critical temperature reached! Forcing device into freeze mode!\n");
 	dd->flags |= HFI1_FORCED_FREEZE;
-	start_freeze_handling(ppd, FREEZE_SELF|FREEZE_ABORT);
+	start_freeze_handling(ppd, FREEZE_SELF | FREEZE_ABORT);
 	/*
 	 * Shut DC down as much and as quickly as possible.
 	 *
diff --git a/drivers/staging/rdma/hfi1/debugfs.c b/drivers/staging/rdma/hfi1/debugfs.c
index d6dc339..0ee7217 100644
--- a/drivers/staging/rdma/hfi1/debugfs.c
+++ b/drivers/staging/rdma/hfi1/debugfs.c
@@ -750,7 +750,7 @@ void hfi1_dbg_ibdev_init(struct hfi1_ibdev *ibd)
 					    ppd,
 					    &port_cntr_ops[i].ops,
 					    port_cntr_ops[i].ops.write == NULL ?
-					    S_IRUGO : S_IRUGO|S_IWUSR);
+					    S_IRUGO : S_IRUGO | S_IWUSR);
 		}
 }
 
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 5d012fe..dd5187f 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -702,7 +702,7 @@ static inline int process_rcv_packet(struct hfi1_packet *packet, int thread)
 		 */
 		prefetch_range(packet->ebuf,
 			packet->tlen - ((packet->rcd->rcvhdrqentsize -
-				  (rhf_hdrq_offset(packet->rhf)+2)) * 4));
+				  (rhf_hdrq_offset(packet->rhf) + 2)) * 4));
 	}
 
 	/*
diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index 29958aa..9a0ddd7 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -99,7 +99,7 @@
 
 /* sleep length while waiting for controller */
 #define WAIT_SLEEP_US 100	/* must be larger than 5 (see usage) */
-#define COUNT_DELAY_SEC(n) ((n) * (1000000/WAIT_SLEEP_US))
+#define COUNT_DELAY_SEC(n) ((n) * (1000000 / WAIT_SLEEP_US))
 
 /* GPIO pins */
 #define EPROM_WP_N (1ull << 14)	/* EPROM write line */
@@ -254,7 +254,7 @@ static void read_page(struct hfi1_devdata *dd, u32 offset, u32 *result)
 	int i;
 
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_READ_DATA(offset));
-	for (i = 0; i < EP_PAGE_SIZE/sizeof(u32); i++)
+	for (i = 0; i < EP_PAGE_SIZE / sizeof(u32); i++)
 		result[i] = (u32)read_csr(dd, ASIC_EEP_DATA);
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_NOP); /* close open page */
 }
@@ -265,7 +265,7 @@ static void read_page(struct hfi1_devdata *dd, u32 offset, u32 *result)
 static int read_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
 {
 	u32 offset;
-	u32 buffer[EP_PAGE_SIZE/sizeof(u32)];
+	u32 buffer[EP_PAGE_SIZE / sizeof(u32)];
 	int ret = 0;
 
 	/* reject anything not on an EPROM page boundary */
@@ -296,7 +296,7 @@ static int write_page(struct hfi1_devdata *dd, u32 offset, u32 *data)
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_WRITE_ENABLE);
 	write_csr(dd, ASIC_EEP_DATA, data[0]);
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_PAGE_PROGRAM(offset));
-	for (i = 1; i < EP_PAGE_SIZE/sizeof(u32); i++)
+	for (i = 1; i < EP_PAGE_SIZE / sizeof(u32); i++)
 		write_csr(dd, ASIC_EEP_DATA, data[i]);
 	/* will close the open page */
 	return wait_for_not_busy(dd);
@@ -308,7 +308,7 @@ static int write_page(struct hfi1_devdata *dd, u32 offset, u32 *data)
 static int write_length(struct hfi1_devdata *dd, u32 start, u32 len, u64 addr)
 {
 	u32 offset;
-	u32 buffer[EP_PAGE_SIZE/sizeof(u32)];
+	u32 buffer[EP_PAGE_SIZE / sizeof(u32)];
 	int ret = 0;
 
 	/* reject anything not on an EPROM page boundary */
diff --git a/drivers/staging/rdma/hfi1/firmware.c b/drivers/staging/rdma/hfi1/firmware.c
index 35084b7..f87460d 100644
--- a/drivers/staging/rdma/hfi1/firmware.c
+++ b/drivers/staging/rdma/hfi1/firmware.c
@@ -393,17 +393,17 @@ static int verify_css_header(struct hfi1_devdata *dd, struct css_header *css)
 	/* verify CSS header fields (most sizes are in DW, so add /4) */
 	if (invalid_header(dd, "module_type", css->module_type, CSS_MODULE_TYPE)
 			|| invalid_header(dd, "header_len", css->header_len,
-					(sizeof(struct firmware_file)/4))
+					(sizeof(struct firmware_file) / 4))
 			|| invalid_header(dd, "header_version",
 					css->header_version, CSS_HEADER_VERSION)
 			|| invalid_header(dd, "module_vendor",
 					css->module_vendor, CSS_MODULE_VENDOR)
 			|| invalid_header(dd, "key_size",
-					css->key_size, KEY_SIZE/4)
+					css->key_size, KEY_SIZE / 4)
 			|| invalid_header(dd, "modulus_size",
-					css->modulus_size, KEY_SIZE/4)
+					css->modulus_size, KEY_SIZE / 4)
 			|| invalid_header(dd, "exponent_size",
-					css->exponent_size, EXPONENT_SIZE/4)) {
+					css->exponent_size, EXPONENT_SIZE / 4)) {
 		return -EINVAL;
 	}
 	return 0;
@@ -488,7 +488,7 @@ static int obtain_one_firmware(struct hfi1_devdata *dd, const char *name,
 	ret = verify_css_header(dd, css);
 	if (ret) {
 		dd_dev_info(dd, "Invalid CSS header for \"%s\"\n", name);
-	} else if ((css->size*4) == fdet->fw->size) {
+	} else if ((css->size * 4) == fdet->fw->size) {
 		/* non-augmented firmware file */
 		struct firmware_file *ff = (struct firmware_file *)
 							fdet->fw->data;
@@ -513,7 +513,7 @@ static int obtain_one_firmware(struct hfi1_devdata *dd, const char *name,
 			dd_dev_err(dd, "driver is unable to validate firmware without r2 and mu (not in firmware file)\n");
 			ret = -EINVAL;
 		}
-	} else if ((css->size*4) + AUGMENT_SIZE == fdet->fw->size) {
+	} else if ((css->size * 4) + AUGMENT_SIZE == fdet->fw->size) {
 		/* augmented firmware file */
 		struct augmented_firmware_file *aff =
 			(struct augmented_firmware_file *)fdet->fw->data;
@@ -536,7 +536,7 @@ static int obtain_one_firmware(struct hfi1_devdata *dd, const char *name,
 		/* css->size check failed */
 		dd_dev_err(dd,
 			"invalid firmware header field size: expected 0x%lx or 0x%lx, actual 0x%x\n",
-			fdet->fw->size/4, (fdet->fw->size - AUGMENT_SIZE)/4,
+			fdet->fw->size / 4, (fdet->fw->size - AUGMENT_SIZE) / 4,
 			css->size);
 
 		ret = -EINVAL;
@@ -780,7 +780,7 @@ static int retry_firmware(struct hfi1_devdata *dd, int load_result)
 static void write_rsa_data(struct hfi1_devdata *dd, int what,
 			   const u8 *data, int nbytes)
 {
-	int qw_size = nbytes/8;
+	int qw_size = nbytes / 8;
 	int i;
 
 	if (((unsigned long)data & 0x7) == 0) {
@@ -788,14 +788,14 @@ static void write_rsa_data(struct hfi1_devdata *dd, int what,
 		u64 *ptr = (u64 *)data;
 
 		for (i = 0; i < qw_size; i++, ptr++)
-			write_csr(dd, what + (8*i), *ptr);
+			write_csr(dd, what + (8 * i), *ptr);
 	} else {
 		/* not aligned */
 		for (i = 0; i < qw_size; i++, data += 8) {
 			u64 value;
 
 			memcpy(&value, data, 8);
-			write_csr(dd, what + (8*i), value);
+			write_csr(dd, what + (8 * i), value);
 		}
 	}
 }
@@ -808,7 +808,7 @@ static void write_streamed_rsa_data(struct hfi1_devdata *dd, int what,
 				    const u8 *data, int nbytes)
 {
 	u64 *ptr = (u64 *)data;
-	int qw_size = nbytes/8;
+	int qw_size = nbytes / 8;
 
 	for (; qw_size > 0; qw_size--, ptr++)
 		write_csr(dd, what, *ptr);
@@ -1743,8 +1743,8 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 			if (len < field_len_bits)
 				return -EINVAL;
 
-			seek = field_start_bits/8;
-			wlen = field_len_bits/8;
+			seek = field_start_bits / 8;
+			wlen = field_len_bits / 8;
 
 			src_ptr = (u32 *)((u8 *)src_ptr + seek);
 
@@ -1783,7 +1783,7 @@ int get_platform_config_field(struct hfi1_devdata *dd,
 	if (!src_ptr || len < field_len_bits)
 		return -EINVAL;
 
-	src_ptr += (field_start_bits/32);
+	src_ptr += (field_start_bits / 32);
 	*data = (*src_ptr >> (field_start_bits % 32)) &
 			((1 << field_len_bits) - 1);
 
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index e8c4e56..70decdf 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -718,7 +718,7 @@ struct hfi1_pportdata {
 	/* begin congestion log related entries
 	 * cc_log_lock protects all congestion log related data */
 	spinlock_t cc_log_lock ____cacheline_aligned_in_smp;
-	u8 threshold_cong_event_map[OPA_MAX_SLS/8];
+	u8 threshold_cong_event_map[OPA_MAX_SLS / 8];
 	u16 threshold_event_counter;
 	struct opa_hfi1_cong_log_event_internal cc_events[OPA_CONG_LOG_ELEMS];
 	int cc_log_idx; /* index for logging events */
diff --git a/drivers/staging/rdma/hfi1/intr.c b/drivers/staging/rdma/hfi1/intr.c
index 9adab86..5e6d77d 100644
--- a/drivers/staging/rdma/hfi1/intr.c
+++ b/drivers/staging/rdma/hfi1/intr.c
@@ -166,7 +166,7 @@ void handle_linkup_change(struct hfi1_devdata *dd, u32 linkup)
 		reset_link_credits(dd);
 
 		/* freeze after a link down to guarantee a clean egress */
-		start_freeze_handling(ppd, FREEZE_SELF|FREEZE_LINK_DOWN);
+		start_freeze_handling(ppd, FREEZE_SELF | FREEZE_LINK_DOWN);
 
 		ev = IB_EVENT_PORT_ERR;
 
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index d9efe22..1a9eb50 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -534,7 +534,7 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	ppd = dd->pport + (port - 1);
 	ibp = &ppd->ibport_data;
 
-	if (ppd->vls_supported/2 > ARRAY_SIZE(pi->neigh_mtu.pvlx_to_mtu) ||
+	if (ppd->vls_supported / 2 > ARRAY_SIZE(pi->neigh_mtu.pvlx_to_mtu) ||
 		ppd->vls_supported > ARRAY_SIZE(dd->vld)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
@@ -600,13 +600,13 @@ static int __subn_get_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	for (i = 0; i < ppd->vls_supported; i++) {
 		mtu = mtu_to_enum(dd->vld[i].mtu, HFI1_DEFAULT_ACTIVE_MTU);
 		if ((i % 2) == 0)
-			pi->neigh_mtu.pvlx_to_mtu[i/2] |= (mtu << 4);
+			pi->neigh_mtu.pvlx_to_mtu[i / 2] |= (mtu << 4);
 		else
-			pi->neigh_mtu.pvlx_to_mtu[i/2] |= mtu;
+			pi->neigh_mtu.pvlx_to_mtu[i / 2] |= mtu;
 	}
 	/* don't forget VL 15 */
 	mtu = mtu_to_enum(dd->vld[15].mtu, 2048);
-	pi->neigh_mtu.pvlx_to_mtu[15/2] |= mtu;
+	pi->neigh_mtu.pvlx_to_mtu[15 / 2] |= mtu;
 	pi->smsl = ibp->rvp.sm_sl & OPA_PI_MASK_SMSL;
 	pi->operational_vls = hfi1_get_ib_cfg(ppd, HFI1_IB_CFG_OP_VLS);
 	pi->partenforce_filterraw |=
@@ -744,7 +744,7 @@ static int __subn_get_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	n_blocks_avail = (u16) (npkeys/OPA_PARTITION_TABLE_BLK_SIZE) + 1;
+	n_blocks_avail = (u16) (npkeys / OPA_PARTITION_TABLE_BLK_SIZE) + 1;
 
 	size = (n_blocks_req * OPA_PARTITION_TABLE_BLK_SIZE) * sizeof(u16);
 
@@ -1207,17 +1207,17 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	(void)hfi1_set_ib_cfg(ppd, HFI1_IB_CFG_VL_HIGH_LIMIT,
 				    ibp->rvp.vl_high_limit);
 
-	if (ppd->vls_supported/2 > ARRAY_SIZE(pi->neigh_mtu.pvlx_to_mtu) ||
+	if (ppd->vls_supported / 2 > ARRAY_SIZE(pi->neigh_mtu.pvlx_to_mtu) ||
 		ppd->vls_supported > ARRAY_SIZE(dd->vld)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		return reply((struct ib_mad_hdr *)smp);
 	}
 	for (i = 0; i < ppd->vls_supported; i++) {
 		if ((i % 2) == 0)
-			mtu = enum_to_mtu((pi->neigh_mtu.pvlx_to_mtu[i/2] >> 4)
+			mtu = enum_to_mtu((pi->neigh_mtu.pvlx_to_mtu[i / 2] >> 4)
 					  & 0xF);
 		else
-			mtu = enum_to_mtu(pi->neigh_mtu.pvlx_to_mtu[i/2] & 0xF);
+			mtu = enum_to_mtu(pi->neigh_mtu.pvlx_to_mtu[i / 2] & 0xF);
 		if (mtu == 0xffff) {
 			pr_warn("SubnSet(OPA_PortInfo) mtu invalid %d (0x%x)\n",
 				mtu,
@@ -1236,7 +1236,7 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 	/* As per OPAV1 spec: VL15 must support and be configured
 	 * for operation with a 2048 or larger MTU.
 	 */
-	mtu = enum_to_mtu(pi->neigh_mtu.pvlx_to_mtu[15/2] & 0xF);
+	mtu = enum_to_mtu(pi->neigh_mtu.pvlx_to_mtu[15 / 2] & 0xF);
 	if (mtu < 2048 || mtu == 0xffff)
 		mtu = 2048;
 	if (dd->vld[15].mtu != mtu) {
@@ -1419,7 +1419,7 @@ static int __subn_set_opa_pkeytable(struct opa_smp *smp, u32 am, u8 *data,
 		return reply((struct ib_mad_hdr *)smp);
 	}
 
-	n_blocks_avail = (u16)(npkeys/OPA_PARTITION_TABLE_BLK_SIZE) + 1;
+	n_blocks_avail = (u16)(npkeys / OPA_PARTITION_TABLE_BLK_SIZE) + 1;
 
 	if (start_block + n_blocks_sent > n_blocks_avail ||
 	    n_blocks_sent > OPA_NUM_PKEY_BLOCKS_PER_SMP) {
@@ -3460,7 +3460,7 @@ static int __subn_get_opa_cc_table(struct opa_smp *smp, u32 am, u8 *data,
 	rcu_read_unlock();
 
 	if (resp_len)
-		*resp_len += sizeof(u16)*(IB_CCT_ENTRIES * n_blocks + 1);
+		*resp_len += sizeof(u16) * (IB_CCT_ENTRIES * n_blocks + 1);
 
 	return reply((struct ib_mad_hdr *)smp);
 }
diff --git a/drivers/staging/rdma/hfi1/mad.h b/drivers/staging/rdma/hfi1/mad.h
index f031775..b6c88be 100644
--- a/drivers/staging/rdma/hfi1/mad.h
+++ b/drivers/staging/rdma/hfi1/mad.h
@@ -267,7 +267,7 @@ struct opa_hfi1_cong_log {
 	u8 congestion_flags;
 	__be16 threshold_event_counter;
 	__be32 current_time_stamp;
-	u8 threshold_cong_event_map[OPA_MAX_SLS/8];
+	u8 threshold_cong_event_map[OPA_MAX_SLS / 8];
 	struct opa_hfi1_cong_log_event events[OPA_CONG_LOG_ELEMS];
 } __packed;
 
diff --git a/drivers/staging/rdma/hfi1/pcie.c b/drivers/staging/rdma/hfi1/pcie.c
index 04f2d8a..019b4f8 100644
--- a/drivers/staging/rdma/hfi1/pcie.c
+++ b/drivers/staging/rdma/hfi1/pcie.c
@@ -840,7 +840,7 @@ static void write_gasket_interrupt(struct hfi1_devdata *dd, int index,
 {
 	write_csr(dd, ASIC_PCIE_SD_INTRPT_LIST + (index * 8),
 	    (((u64)code << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_CODE_SHIFT)
-	    |((u64)data << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_DATA_SHIFT)));
+	    | ((u64)data << ASIC_PCIE_SD_INTRPT_LIST_INTRPT_DATA_SHIFT)));
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index 69bbe22..9bafedf 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -101,7 +101,7 @@ void pio_send_control(struct hfi1_devdata *dd, int op)
 	/* Fall through */
 	case PSC_DATA_VL_ENABLE:
 		/* Disallow sending on VLs not enabled */
-		mask = (((~0ull)<<num_vls) & SEND_CTRL_UNSUPPORTED_VL_MASK)<<
+		mask = (((~0ull) << num_vls) & SEND_CTRL_UNSUPPORTED_VL_MASK) <<
 				SEND_CTRL_UNSUPPORTED_VL_SHIFT;
 		reg = (reg & ~SEND_CTRL_UNSUPPORTED_VL_SMASK) | mask;
 		break;
@@ -1346,7 +1346,7 @@ void sc_stop(struct send_context *sc, int flag)
 	wake_up(&sc->halt_wait);
 }
 
-#define BLOCK_DWORDS (PIO_BLOCK_SIZE/sizeof(u32))
+#define BLOCK_DWORDS (PIO_BLOCK_SIZE / sizeof(u32))
 #define dwords_to_blocks(x) DIV_ROUND_UP(x, BLOCK_DWORDS)
 
 /*
diff --git a/drivers/staging/rdma/hfi1/pio_copy.c b/drivers/staging/rdma/hfi1/pio_copy.c
index ebb0baf..dc0c178 100644
--- a/drivers/staging/rdma/hfi1/pio_copy.c
+++ b/drivers/staging/rdma/hfi1/pio_copy.c
@@ -52,9 +52,9 @@
 
 /* additive distance between non-SOP and SOP space */
 #define SOP_DISTANCE (TXE_PIO_SIZE / 2)
-#define PIO_BLOCK_MASK (PIO_BLOCK_SIZE-1)
+#define PIO_BLOCK_MASK (PIO_BLOCK_SIZE - 1)
 /* number of QUADWORDs in a block */
-#define PIO_BLOCK_QWS (PIO_BLOCK_SIZE/sizeof(u64))
+#define PIO_BLOCK_QWS (PIO_BLOCK_SIZE / sizeof(u64))
 
 /**
  * pio_copy - copy data block to MMIO space
@@ -83,7 +83,7 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
 	dest += sizeof(u64);
 
 	/* calculate where the QWORD data ends - in SOP=1 space */
-	dend = dest + ((count>>1) * sizeof(u64));
+	dend = dest + ((count >> 1) * sizeof(u64));
 
 	if (dend < send) {
 		/* all QWORD data is within the SOP block, does *not*
@@ -177,7 +177,7 @@ void pio_copy(struct hfi1_devdata *dd, struct pio_buf *pbuf, u64 pbc,
  * "zero" shift - bit shift used to zero out upper bytes.  Input is
  * the count of LSB bytes to preserve.
  */
-#define zshift(x) (8 * (8-(x)))
+#define zshift(x) (8 * (8 - (x)))
 
 /*
  * "merge" shift - bit shift used to merge with carry bytes.  Input is
@@ -244,7 +244,7 @@ static inline void read_extra_bytes(struct pio_buf *pbuf,
 		pbuf->carry.val64 |= (((*(u64 *)from)
 					>> mshift(off))
 					<< zshift(xbytes))
-					>> zshift(xbytes+pbuf->carry_bytes);
+					>> zshift(xbytes + pbuf->carry_bytes);
 		off = 0;
 		pbuf->carry_bytes += xbytes;
 		nbytes -= xbytes;
@@ -411,7 +411,7 @@ static inline void merge_write8(
 
 	jcopy(&pbuf->carry.val8[pbuf->carry_bytes], src, remainder);
 	writeq(pbuf->carry.val64, dest);
-	jcopy(&pbuf->carry.val8[0], src+remainder, pbuf->carry_bytes);
+	jcopy(&pbuf->carry.val8[0], src + remainder, pbuf->carry_bytes);
 }
 
 /*
@@ -463,7 +463,7 @@ void seg_pio_copy_start(struct pio_buf *pbuf, u64 pbc,
 	dest += sizeof(u64);
 
 	/* calculate where the QWORD data ends - in SOP=1 space */
-	dend = dest + ((nbytes>>3) * sizeof(u64));
+	dend = dest + ((nbytes >> 3) * sizeof(u64));
 
 	if (dend < send) {
 		/* all QWORD data is within the SOP block, does *not*
@@ -645,7 +645,7 @@ static void mid_copy_straight(struct pio_buf *pbuf,
 	void __iomem *dend;			/* 8-byte data end */
 
 	/* calculate 8-byte data end */
-	dend = dest + ((nbytes>>3) * sizeof(u64));
+	dend = dest + ((nbytes >> 3) * sizeof(u64));
 
 	if (pbuf->qw_written < PIO_BLOCK_QWS) {
 		/*
@@ -713,7 +713,7 @@ static void mid_copy_straight(struct pio_buf *pbuf,
 	/* we know carry_bytes was zero on entry to this routine */
 	read_low_bytes(pbuf, from, nbytes & 0x7);
 
-	pbuf->qw_written += nbytes>>3;
+	pbuf->qw_written += nbytes >> 3;
 }
 
 /*
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index 42e5be4..a6d55a6 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -339,7 +339,7 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 	u8 *cache = &cp->cache[0];
 
 	/* ensure sane contents on invalid reads, for cable swaps */
-	memset(cache, 0, (QSFP_MAX_NUM_PAGES*128));
+	memset(cache, 0, (QSFP_MAX_NUM_PAGES * 128));
 	spin_lock_irqsave(&ppd->qsfp_info.qsfp_lock, flags);
 	ppd->qsfp_info.cache_valid = 0;
 	spin_unlock_irqrestore(&ppd->qsfp_info.qsfp_lock, flags);
@@ -420,7 +420,7 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 	return 0;
 
 bail:
-	memset(cache, 0, (QSFP_MAX_NUM_PAGES*128));
+	memset(cache, 0, (QSFP_MAX_NUM_PAGES * 128));
 	return ret;
 }
 
@@ -564,7 +564,7 @@ int qsfp_dump(struct hfi1_pportdata *ppd, char *buf, int len)
 
 			memcpy(bin_buff, &cache[bidx], QSFP_DUMP_CHUNK);
 			for (iidx = 0; iidx < QSFP_DUMP_CHUNK; ++iidx) {
-				sofar += scnprintf(buf + sofar, len-sofar,
+				sofar += scnprintf(buf + sofar, len - sofar,
 					" %02X", bin_buff[iidx]);
 			}
 			sofar += scnprintf(buf + sofar, len - sofar, "\n");
diff --git a/drivers/staging/rdma/hfi1/qsfp.h b/drivers/staging/rdma/hfi1/qsfp.h
index af59a43..9f6e2f3 100644
--- a/drivers/staging/rdma/hfi1/qsfp.h
+++ b/drivers/staging/rdma/hfi1/qsfp.h
@@ -214,7 +214,7 @@ struct qsfp_data {
 	/* Helps to find our way */
 	struct hfi1_pportdata *ppd;
 	struct work_struct qsfp_work;
-	u8 cache[QSFP_MAX_NUM_PAGES*128];
+	u8 cache[QSFP_MAX_NUM_PAGES * 128];
 	spinlock_t qsfp_lock;
 	u8 check_interrupt_flags;
 	u8 reset_needed;
diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index 443fda8..5cdf1d2 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -1992,7 +1992,7 @@ static void log_cca_event(struct hfi1_pportdata *ppd, u8 sl, u32 rlid,
 
 	spin_lock_irqsave(&ppd->cc_log_lock, flags);
 
-	ppd->threshold_cong_event_map[sl/8] |= 1 << (sl % 8);
+	ppd->threshold_cong_event_map[sl / 8] |= 1 << (sl % 8);
 	ppd->threshold_event_counter++;
 
 	cc_event = &ppd->cc_events[ppd->cc_log_idx++];
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 3f29f0a..2e574ef 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1020,7 +1020,7 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		dd->chip_sdma_mem_size);
 
 	per_sdma_credits =
-		dd->chip_sdma_mem_size/(num_engines * SDMA_BLOCK_SIZE);
+		dd->chip_sdma_mem_size / (num_engines * SDMA_BLOCK_SIZE);
 
 	/* set up freeze waitqueue */
 	init_waitqueue_head(&dd->sdma_unfreeze_wq);
@@ -1051,12 +1051,12 @@ int sdma_init(struct hfi1_devdata *dd, u8 port)
 		sde->sdma_mask = (1 << sde->sdma_shift) - 1;
 
 		/* Create a mask for all 3 chip interrupt sources */
-		sde->imask = (u64)1 << (0*TXE_NUM_SDMA_ENGINES + this_idx)
-			| (u64)1 << (1*TXE_NUM_SDMA_ENGINES + this_idx)
-			| (u64)1 << (2*TXE_NUM_SDMA_ENGINES + this_idx);
+		sde->imask = (u64)1 << (0 * TXE_NUM_SDMA_ENGINES + this_idx)
+			| (u64)1 << (1 * TXE_NUM_SDMA_ENGINES + this_idx)
+			| (u64)1 << (2 * TXE_NUM_SDMA_ENGINES + this_idx);
 		/* Create a mask specifically for sdma_idle */
 		sde->idle_mask =
-			(u64)1 << (2*TXE_NUM_SDMA_ENGINES + this_idx);
+			(u64)1 << (2 * TXE_NUM_SDMA_ENGINES + this_idx);
 		/* Create a mask specifically for sdma_progress */
 		sde->progress_mask =
 			(u64)1 << (TXE_NUM_SDMA_ENGINES + this_idx);
@@ -1626,10 +1626,10 @@ static void sdma_setlengen(struct sdma_engine *sde)
 	 * generation counter.
 	 */
 	write_sde_csr(sde, SD(LEN_GEN),
-		(sde->descq_cnt/64) << SD(LEN_GEN_LENGTH_SHIFT)
+		(sde->descq_cnt / 64) << SD(LEN_GEN_LENGTH_SHIFT)
 	);
 	write_sde_csr(sde, SD(LEN_GEN),
-		((sde->descq_cnt/64) << SD(LEN_GEN_LENGTH_SHIFT))
+		((sde->descq_cnt / 64) << SD(LEN_GEN_LENGTH_SHIFT))
 		| (4ULL << SD(LEN_GEN_GENERATION_SHIFT))
 	);
 }
@@ -3058,5 +3058,5 @@ void _sdma_engine_progress_schedule(
 	trace_hfi1_sdma_engine_progress(sde, sde->progress_mask);
 	/* assume we have selected a good cpu */
 	write_csr(sde->dd,
-		  CCE_INT_FORCE + (8*(IS_SDMA_START/64)), sde->progress_mask);
+		  CCE_INT_FORCE + (8 * (IS_SDMA_START / 64)), sde->progress_mask);
 }
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index f24b5a1..c106d3c 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -682,7 +682,7 @@ static inline void _sdma_close_tx(struct hfi1_devdata *dd,
 		dd->default_desc1;
 	if (tx->flags & SDMA_TXREQ_F_URGENT)
 		tx->descp[tx->num_desc].qw[1] |=
-			(SDMA_DESC1_HEAD_TO_HOST_FLAG|
+			(SDMA_DESC1_HEAD_TO_HOST_FLAG |
 			 SDMA_DESC1_INT_REQ_FLAG);
 }
 
diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index dfa9ef2..9fe18b0 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -1204,7 +1204,7 @@ static int set_txreq_header(struct user_sdma_request *req,
 
 	/* Set ACK request on last packet */
 	if (unlikely(tx->flags & TXREQ_FLAGS_REQ_LAST_PKT))
-		hdr->bth[2] |= cpu_to_be32(1UL<<31);
+		hdr->bth[2] |= cpu_to_be32(1UL << 31);
 
 	/* Set the new offset */
 	hdr->kdeth.swdata[6] = cpu_to_le32(req->koffset);
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 10b14da..acf1132 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -874,7 +874,7 @@ int hfi1_verbs_send_pio(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
 		pio_copy(ppd->dd, pbuf, pbc, hdr, hdrwords);
 	} else {
 		if (ss) {
-			seg_pio_copy_start(pbuf, pbc, hdr, hdrwords*4);
+			seg_pio_copy_start(pbuf, pbc, hdr, hdrwords * 4);
 			while (len) {
 				void *addr = ss->sge.vaddr;
 				u32 slen = ss->sge.length;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
