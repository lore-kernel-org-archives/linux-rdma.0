From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] staging/rdma/hfi1: check for ARMED->ACTIVE transition in receive interrupt
Date: Thu, 17 Dec 2015 19:24:15 -0500
Message-ID: <1450398255-10346-3-git-send-email-jubin.john@intel.com>
References: <1450398255-10346-1-git-send-email-jubin.john@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450398255-10346-1-git-send-email-jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The link state will transition from ARMED to ACTIVE when a non-SC15
packet arrives, but the driver might not notice the change.  With this
fix, if the slowpath receive interrupt handler sees a non-SC15 packet
while in the ARMED state, we queue work to call linkstate_active_work
from process context to promote it to ACTIVE.

Signed-off-by: Jim Snow <jim.m.snow-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Brendan Cunningham <brendan.cunningham-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c   |    5 ++-
 drivers/staging/rdma/hfi1/chip.h   |    2 +
 drivers/staging/rdma/hfi1/driver.c |   66 ++++++++++++++++++++++++++++++++++++
 drivers/staging/rdma/hfi1/hfi.h    |   12 ++++++
 drivers/staging/rdma/hfi1/init.c   |    1 +
 5 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 78a5f08..f82b848 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -4606,7 +4606,7 @@ static inline void clear_recv_intr(struct hfi1_ctxtdata *rcd)
 }
 
 /* force the receive interrupt */
-static inline void force_recv_intr(struct hfi1_ctxtdata *rcd)
+void force_recv_intr(struct hfi1_ctxtdata *rcd)
 {
 	write_csr(rcd->dd, CCE_INT_FORCE + (8 * rcd->ireg), rcd->imask);
 }
@@ -4705,7 +4705,7 @@ u32 read_physical_state(struct hfi1_devdata *dd)
 				& DC_DC8051_STS_CUR_STATE_PORT_MASK;
 }
 
-static u32 read_logical_state(struct hfi1_devdata *dd)
+u32 read_logical_state(struct hfi1_devdata *dd)
 {
 	u64 reg;
 
@@ -6658,6 +6658,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 				ppd->link_enabled = 1;
 		}
 
+		set_all_slowpath(ppd->dd);
 		ret = set_local_link_attributes(ppd);
 		if (ret)
 			break;
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index d74aed8..620cf08 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -691,6 +691,8 @@ u64 read_dev_cntr(struct hfi1_devdata *dd, int index, int vl);
 u64 write_dev_cntr(struct hfi1_devdata *dd, int index, int vl, u64 data);
 u64 read_port_cntr(struct hfi1_pportdata *ppd, int index, int vl);
 u64 write_port_cntr(struct hfi1_pportdata *ppd, int index, int vl, u64 data);
+u32 read_logical_state(struct hfi1_devdata *dd);
+void force_recv_intr(struct hfi1_ctxtdata *rcd);
 
 /* Per VL indexes */
 enum {
diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 4c52e78..16b1be1 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -862,6 +862,15 @@ static inline void set_all_dma_rtail(struct hfi1_devdata *dd)
 			&handle_receive_interrupt_dma_rtail;
 }
 
+void set_all_slowpath(struct hfi1_devdata *dd)
+{
+	int i;
+
+	for (i = HFI1_CTRL_CTXT + 1; i < dd->first_user_ctxt; i++)
+		dd->rcd[i]->do_interrupt =
+		  &handle_receive_interrupt;
+}
+
 /*
  * handle_receive_interrupt - receive a packet
  * @rcd: the context
@@ -929,6 +938,27 @@ int handle_receive_interrupt(struct hfi1_ctxtdata *rcd, int thread)
 			last = skip_rcv_packet(&packet, thread);
 			skip_pkt = 0;
 		} else {
+			/* Auto activate link on non-SC15 packet receive */
+			if (unlikely(rcd->ppd->host_link_state ==
+				     HLS_UP_ARMED)) {
+				struct work_struct *lsaw =
+				  &rcd->ppd->linkstate_active_work;
+				struct hfi1_message_header *hdr =
+				  hfi1_get_msgheader(packet.rcd->dd,
+						     packet.rhf_addr);
+				if (hdr2sc(hdr, packet.rhf) != 0xf) {
+					int hwstate = read_logical_state(dd);
+
+					if (hwstate != LSTATE_ACTIVE) {
+						dd_dev_info(dd, "Unexpected link state %d\n",
+							    hwstate);
+					} else {
+						queue_work(
+						  rcd->ppd->hfi1_wq, lsaw);
+						goto bail;
+					}
+				}
+			}
 			last = process_rcv_packet(&packet, thread);
 		}
 
@@ -984,6 +1014,42 @@ bail:
 }
 
 /*
+ * We may discover in the interrupt that the hardware link state has
+ * changed from ARMED to ACTIVE (due to the arrival of a non-SC15 packet),
+ * and we need to update the driver's notion of the link state.  We cannot
+ * run set_link_state from interrupt context, so we queue this function on
+ * a workqueue.
+ *
+ * We delay the regular interrupt processing until after the state changes
+ * so that the link will be in the correct state by the time any application
+ * we wake up attempts to send a reply to any message it received.
+ * (Subsequent receive interrupts may possibly force the wakeup before we
+ * update the link state.)
+ *
+ * The rcd is freed in hfi1_free_ctxtdata after hfi1_postinit_cleanup invokes
+ * dd->f_cleanup(dd) to disable the interrupt handler and flush workqueues,
+ * so we're safe from use-after-free of the rcd.
+ */
+void receive_interrupt_work(struct work_struct *work)
+{
+	struct hfi1_pportdata *ppd =
+	  container_of(work, struct hfi1_pportdata, linkstate_active_work);
+	struct hfi1_devdata *dd = ppd->dd;
+	int i;
+
+	/* Received non-SC15 packet implies neighbor_normal */
+	ppd->neighbor_normal = 1;
+	set_link_state(ppd, HLS_UP_ACTIVE);
+
+	/*
+	 * Interrupt all kernel contexts that could have had an
+	 *  interrupt during auto activation.
+	 */
+	for (i = HFI1_CTRL_CTXT; i < dd->first_user_ctxt; i++)
+		force_recv_intr(dd->rcd[i]);
+}
+
+/*
  * Convert a given MTU size to the on-wire MAD packet enumeration.
  * Return -1 if the size is invalid.
  */
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 54ed6b3..bfd9723 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -712,6 +712,7 @@ struct hfi1_pportdata {
 	u8 remote_link_down_reason;
 	/* Error events that will cause a port bounce. */
 	u32 port_error_action;
+	struct work_struct linkstate_active_work;
 };
 
 typedef int (*rhf_rcv_function_ptr)(struct hfi1_packet *packet);
@@ -1128,6 +1129,7 @@ void hfi1_free_ctxtdata(struct hfi1_devdata *, struct hfi1_ctxtdata *);
 int handle_receive_interrupt(struct hfi1_ctxtdata *, int);
 int handle_receive_interrupt_nodma_rtail(struct hfi1_ctxtdata *, int);
 int handle_receive_interrupt_dma_rtail(struct hfi1_ctxtdata *, int);
+void set_all_slowpath(struct hfi1_devdata *dd);
 
 /* receive packet handler dispositions */
 #define RCV_PKT_OK      0x0 /* keep going */
@@ -1148,6 +1150,16 @@ static inline u32 driver_lstate(struct hfi1_pportdata *ppd)
 	return ppd->lstate; /* use the cached value */
 }
 
+void receive_interrupt_work(struct work_struct *work);
+
+/* extract service channel from header and rhf */
+static inline int hdr2sc(struct hfi1_message_header *hdr, u64 rhf)
+{
+	return
+		((be16_to_cpu(hdr->lrh[0]) >> 12) & 0xf) |
+		((!!(rhf & RHF_DC_INFO_MASK)) << 4);
+}
+
 static inline u16 generate_jkey(kuid_t uid)
 {
 	return from_kuid(current_user_ns(), uid) & 0xffff;
diff --git a/drivers/staging/rdma/hfi1/init.c b/drivers/staging/rdma/hfi1/init.c
index 8f13d53..ee206ae 100644
--- a/drivers/staging/rdma/hfi1/init.c
+++ b/drivers/staging/rdma/hfi1/init.c
@@ -498,6 +498,7 @@ void hfi1_init_pportdata(struct pci_dev *pdev, struct hfi1_pportdata *ppd,
 	INIT_WORK(&ppd->link_downgrade_work, handle_link_downgrade);
 	INIT_WORK(&ppd->sma_message_work, handle_sma_message);
 	INIT_WORK(&ppd->link_bounce_work, handle_link_bounce);
+	INIT_WORK(&ppd->linkstate_active_work, receive_interrupt_work);
 	mutex_init(&ppd->hls_lock);
 	spin_lock_init(&ppd->sdma_alllock);
 	spin_lock_init(&ppd->qsfp_info.qsfp_lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
