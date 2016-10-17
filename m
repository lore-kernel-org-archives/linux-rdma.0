From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 09/12] IB/hfi1: Remove leftover snoop references
Date: Mon, 17 Oct 2016 04:19:52 -0700
Message-ID: <20161017111952.7934.5202.stgit@scvm10.sc.intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017103326.7934.21558.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A few snoop related variables were missed in the snoop/capture removal
to get out of staging. Go back and clean those up too.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |   18 +---------
 drivers/infiniband/hw/hfi1/hfi.h      |   40 +---------------------
 drivers/infiniband/hw/hfi1/trace_rx.h |   60 ---------------------------------
 3 files changed, 4 insertions(+), 114 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index a0f05d7..bf645e9 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -6301,19 +6301,8 @@ void set_up_vl15(struct hfi1_devdata *dd, u8 vau, u16 vl15buf)
 	/* leave shared count at zero for both global and VL15 */
 	write_global_credit(dd, vau, vl15buf, 0);
 
-	/* We may need some credits for another VL when sending packets
-	 * with the snoop interface. Dividing it down the middle for VL15
-	 * and VL0 should suffice.
-	 */
-	if (unlikely(dd->hfi1_snoop.mode_flag == HFI1_PORT_SNOOP_MODE)) {
-		write_csr(dd, SEND_CM_CREDIT_VL15, (u64)(vl15buf >> 1)
-		    << SEND_CM_CREDIT_VL15_DEDICATED_LIMIT_VL_SHIFT);
-		write_csr(dd, SEND_CM_CREDIT_VL, (u64)(vl15buf >> 1)
-		    << SEND_CM_CREDIT_VL_DEDICATED_LIMIT_VL_SHIFT);
-	} else {
-		write_csr(dd, SEND_CM_CREDIT_VL15, (u64)vl15buf
-			<< SEND_CM_CREDIT_VL15_DEDICATED_LIMIT_VL_SHIFT);
-	}
+	write_csr(dd, SEND_CM_CREDIT_VL15, (u64)vl15buf
+		  << SEND_CM_CREDIT_VL15_DEDICATED_LIMIT_VL_SHIFT);
 }
 
 /*
@@ -9915,9 +9904,6 @@ static void set_lidlmc(struct hfi1_pportdata *ppd)
 	u32 mask = ~((1U << ppd->lmc) - 1);
 	u64 c1 = read_csr(ppd->dd, DCC_CFG_PORT_CONFIG1);
 
-	if (dd->hfi1_snoop.mode_flag)
-		dd_dev_info(dd, "Set lid/lmc while snooping");
-
 	c1 &= ~(DCC_CFG_PORT_CONFIG1_TARGET_DLID_SMASK
 		| DCC_CFG_PORT_CONFIG1_DLID_MASK_SMASK);
 	c1 |= ((ppd->lid & DCC_CFG_PORT_CONFIG1_TARGET_DLID_MASK)
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 94cc5f2..1453c5c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -367,26 +367,6 @@ struct hfi1_packet {
 	u8 etype;
 };
 
-/*
- * Private data for snoop/capture support.
- */
-struct hfi1_snoop_data {
-	int mode_flag;
-	struct cdev cdev;
-	struct device *class_dev;
-	/* protect snoop data */
-	spinlock_t snoop_lock;
-	struct list_head queue;
-	wait_queue_head_t waitq;
-	void *filter_value;
-	int (*filter_callback)(void *hdr, void *data, void *value);
-	u64 dcc_cfg; /* saved value of DCC Cfg register */
-};
-
-/* snoop mode_flag values */
-#define HFI1_PORT_SNOOP_MODE     1U
-#define HFI1_PORT_CAPTURE_MODE   2U
-
 struct rvt_sge_state;
 
 /*
@@ -1094,8 +1074,6 @@ struct hfi1_devdata {
 	char *portcntrnames;
 	size_t portcntrnameslen;
 
-	struct hfi1_snoop_data hfi1_snoop;
-
 	struct err_info_rcvport err_info_rcvport;
 	struct err_info_constraint err_info_rcv_constraint;
 	struct err_info_constraint err_info_xmit_constraint;
@@ -1133,8 +1111,8 @@ struct hfi1_devdata {
 	u64 lcb_err_en;
 
 	/*
-	 * Handlers for outgoing data so that snoop/capture does not
-	 * have to have its hooks in the send path
+	 * Capability to have different send engines simply by changing a
+	 * pointer value.
 	 */
 	send_routine process_pio_send ____cacheline_aligned_in_smp;
 	send_routine process_dma_send;
@@ -1238,8 +1216,6 @@ struct hfi1_devdata *hfi1_lookup(int unit);
 extern u32 hfi1_cpulist_count;
 extern unsigned long *hfi1_cpulist;
 
-extern unsigned int snoop_drop_send;
-extern unsigned int snoop_force_capture;
 int hfi1_init(struct hfi1_devdata *, int);
 int hfi1_count_units(int *npresentp, int *nupp);
 int hfi1_count_active_units(void);
@@ -1574,13 +1550,6 @@ void set_up_vl15(struct hfi1_devdata *dd, u8 vau, u16 vl15buf);
 void reset_link_credits(struct hfi1_devdata *dd);
 void assign_remote_cm_au_table(struct hfi1_devdata *dd, u8 vcu);
 
-int snoop_recv_handler(struct hfi1_packet *packet);
-int snoop_send_dma_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
-			   u64 pbc);
-int snoop_send_pio_handler(struct rvt_qp *qp, struct hfi1_pkt_state *ps,
-			   u64 pbc);
-void snoop_inline_pio_send(struct hfi1_devdata *dd, struct pio_buf *pbuf,
-			   u64 pbc, const void *from, size_t count);
 int set_buffer_control(struct hfi1_pportdata *ppd, struct buffer_control *bc);
 
 static inline struct hfi1_devdata *dd_from_ppd(struct hfi1_pportdata *ppd)
@@ -1827,8 +1796,6 @@ int kdeth_process_expected(struct hfi1_packet *packet);
 int kdeth_process_eager(struct hfi1_packet *packet);
 int process_receive_invalid(struct hfi1_packet *packet);
 
-extern rhf_rcv_function_ptr snoop_rhf_rcv_functions[8];
-
 void update_sge(struct rvt_sge_state *ss, u32 length);
 
 /* global module parameter variables */
@@ -1855,9 +1822,6 @@ extern struct mutex hfi1_mutex;
 #define DRIVER_NAME		"hfi1"
 #define HFI1_USER_MINOR_BASE     0
 #define HFI1_TRACE_MINOR         127
-#define HFI1_DIAGPKT_MINOR       128
-#define HFI1_DIAG_MINOR_BASE     129
-#define HFI1_SNOOP_CAPTURE_BASE  200
 #define HFI1_NMINORS             255
 
 #define PCI_VENDOR_ID_INTEL 0x8086
diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index 11e02b2..f77e59f 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -253,66 +253,6 @@ TRACE_EVENT(hfi1_mmu_invalidate,
 		      )
 	    );
 
-#define SNOOP_PRN \
-	"slid %.4x dlid %.4x qpn 0x%.6x opcode 0x%.2x,%s " \
-	"svc lvl %d pkey 0x%.4x [header = %d bytes] [data = %d bytes]"
-
-TRACE_EVENT(snoop_capture,
-	    TP_PROTO(struct hfi1_devdata *dd,
-		     int hdr_len,
-		     struct ib_header *hdr,
-		     int data_len,
-		     void *data),
-	    TP_ARGS(dd, hdr_len, hdr, data_len, data),
-	    TP_STRUCT__entry(
-			     DD_DEV_ENTRY(dd)
-			     __field(u16, slid)
-			     __field(u16, dlid)
-			     __field(u32, qpn)
-			     __field(u8, opcode)
-			     __field(u8, sl)
-			     __field(u16, pkey)
-			     __field(u32, hdr_len)
-			     __field(u32, data_len)
-			     __field(u8, lnh)
-			     __dynamic_array(u8, raw_hdr, hdr_len)
-			     __dynamic_array(u8, raw_pkt, data_len)
-			     ),
-	    TP_fast_assign(
-		struct ib_other_headers *ohdr;
-
-		__entry->lnh = (u8)(be16_to_cpu(hdr->lrh[0]) & 3);
-		if (__entry->lnh == HFI1_LRH_BTH)
-		ohdr = &hdr->u.oth;
-		else
-		ohdr = &hdr->u.l.oth;
-		DD_DEV_ASSIGN(dd);
-		__entry->slid = be16_to_cpu(hdr->lrh[3]);
-		__entry->dlid = be16_to_cpu(hdr->lrh[1]);
-		__entry->qpn = be32_to_cpu(ohdr->bth[1]) & RVT_QPN_MASK;
-		__entry->opcode = (be32_to_cpu(ohdr->bth[0]) >> 24) & 0xff;
-		__entry->sl = (u8)(be16_to_cpu(hdr->lrh[0]) >> 4) & 0xf;
-		__entry->pkey =	be32_to_cpu(ohdr->bth[0]) & 0xffff;
-		__entry->hdr_len = hdr_len;
-		__entry->data_len = data_len;
-		memcpy(__get_dynamic_array(raw_hdr), hdr, hdr_len);
-		memcpy(__get_dynamic_array(raw_pkt), data, data_len);
-		),
-	    TP_printk(
-		"[%s] " SNOOP_PRN,
-		__get_str(dev),
-		__entry->slid,
-		__entry->dlid,
-		__entry->qpn,
-		__entry->opcode,
-		show_ib_opcode(__entry->opcode),
-		__entry->sl,
-		__entry->pkey,
-		__entry->hdr_len,
-		__entry->data_len
-		)
-);
-
 #endif /* __HFI1_TRACE_RX_H */
 
 #undef TRACE_INCLUDE_PATH

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
