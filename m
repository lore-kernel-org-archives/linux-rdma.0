From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 6/8] IB/hfi1: Create workqueue for link events
Date: Sat, 29 Jul 2017 08:43:49 -0700
Message-ID: <20170729154348.21487.66943.stgit@scvm10.sc.intel.com>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170729154124.21487.53119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currently, link down interrupts queue link entries
on a workqueue intended for sending events only.
Create a workqueue for queuing link events.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c   |   20 ++++++++++----------
 drivers/infiniband/hw/hfi1/driver.c |    2 +-
 drivers/infiniband/hw/hfi1/hfi.h    |    1 +
 drivers/infiniband/hw/hfi1/init.c   |   26 ++++++++++++++++++++++++++
 drivers/infiniband/hw/hfi1/pio.c    |    2 +-
 drivers/infiniband/hw/hfi1/sdma.c   |    2 +-
 6 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index bd594e7..8443d41 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -5545,7 +5545,7 @@ static void update_rcverr_timer(unsigned long opaque)
 		set_link_down_reason(
 		ppd, OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN, 0,
 		OPA_LINKDOWN_REASON_EXCESSIVE_BUFFER_OVERRUN);
-		queue_work(ppd->hfi1_wq, &ppd->link_bounce_work);
+		queue_work(ppd->link_wq, &ppd->link_bounce_work);
 	}
 	dd->rcv_ovfl_cnt = (u32)cur_ovfl_cnt;
 
@@ -6100,7 +6100,7 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 				 * will not happen. We have to do it here
 				 * before turning the DC off.
 				 */
-				queue_work(ppd->hfi1_wq, &ppd->link_down_work);
+				queue_work(ppd->link_wq, &ppd->link_down_work);
 			}
 		} else {
 			dd_dev_info(dd, "%s: QSFP module inserted\n",
@@ -6135,7 +6135,7 @@ static void handle_qsfp_int(struct hfi1_devdata *dd, u32 src_ctx, u64 reg)
 
 	/* Schedule the QSFP work only if there is a cable attached. */
 	if (qsfp_mod_present(ppd))
-		queue_work(ppd->hfi1_wq, &ppd->qsfp_info.qsfp_work);
+		queue_work(ppd->link_wq, &ppd->qsfp_info.qsfp_work);
 }
 
 static int request_host_lcb_access(struct hfi1_devdata *dd)
@@ -7738,12 +7738,12 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			host_msg &= ~(u64)HOST_REQ_DONE;
 		}
 		if (host_msg & BC_SMA_MSG) {
-			queue_work(ppd->hfi1_wq, &ppd->sma_message_work);
+			queue_work(ppd->link_wq, &ppd->sma_message_work);
 			host_msg &= ~(u64)BC_SMA_MSG;
 		}
 		if (host_msg & LINKUP_ACHIEVED) {
 			dd_dev_info(dd, "8051: Link up\n");
-			queue_work(ppd->hfi1_wq, &ppd->link_up_work);
+			queue_work(ppd->link_wq, &ppd->link_up_work);
 			host_msg &= ~(u64)LINKUP_ACHIEVED;
 		}
 		if (host_msg & EXT_DEVICE_CFG_REQ) {
@@ -7751,7 +7751,7 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			host_msg &= ~(u64)EXT_DEVICE_CFG_REQ;
 		}
 		if (host_msg & VERIFY_CAP_FRAME) {
-			queue_work(ppd->hfi1_wq, &ppd->link_vc_work);
+			queue_work(ppd->link_wq, &ppd->link_vc_work);
 			host_msg &= ~(u64)VERIFY_CAP_FRAME;
 		}
 		if (host_msg & LINK_GOING_DOWN) {
@@ -7766,7 +7766,7 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			host_msg &= ~(u64)LINK_GOING_DOWN;
 		}
 		if (host_msg & LINK_WIDTH_DOWNGRADED) {
-			queue_work(ppd->hfi1_wq, &ppd->link_downgrade_work);
+			queue_work(ppd->link_wq, &ppd->link_downgrade_work);
 			host_msg &= ~(u64)LINK_WIDTH_DOWNGRADED;
 		}
 		if (host_msg) {
@@ -7809,7 +7809,7 @@ static void handle_8051_interrupt(struct hfi1_devdata *dd, u32 unused, u64 reg)
 			dd_dev_info(dd, "%s: not queuing link down\n",
 				    __func__);
 		} else {
-			queue_work(ppd->hfi1_wq, &ppd->link_down_work);
+			queue_work(ppd->link_wq, &ppd->link_down_work);
 		}
 	}
 }
@@ -8017,7 +8017,7 @@ static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		dd_dev_info_ratelimited(dd, "%s: PortErrorAction bounce\n",
 					__func__);
 		set_link_down_reason(ppd, lcl_reason, 0, lcl_reason);
-		queue_work(ppd->hfi1_wq, &ppd->link_bounce_work);
+		queue_work(ppd->link_wq, &ppd->link_bounce_work);
 	}
 }
 
@@ -9685,7 +9685,7 @@ static void try_start_link(struct hfi1_pportdata *ppd)
 			    "QSFP not responding, waiting and retrying %d\n",
 			    (int)ppd->qsfp_retry_count);
 		ppd->qsfp_retry_count++;
-		queue_delayed_work(ppd->hfi1_wq, &ppd->start_link_work,
+		queue_delayed_work(ppd->link_wq, &ppd->start_link_work,
 				   msecs_to_jiffies(QSFP_RETRY_WAIT));
 		return;
 	}
diff --git a/drivers/infiniband/hw/hfi1/driver.c b/drivers/infiniband/hw/hfi1/driver.c
index 01235d4..0b7ca0e 100644
--- a/drivers/infiniband/hw/hfi1/driver.c
+++ b/drivers/infiniband/hw/hfi1/driver.c
@@ -914,7 +914,7 @@ static inline int set_armed_to_active(struct hfi1_ctxtdata *rcd,
 			return 0;
 		}
 
-		queue_work(rcd->ppd->hfi1_wq, lsaw);
+		queue_work(rcd->ppd->link_wq, lsaw);
 		return 1;
 	}
 	return 0;
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 2d32c5c..ee6c389 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -576,6 +576,7 @@ struct hfi1_pportdata {
 	/* SendDMA related entries */
 
 	struct workqueue_struct *hfi1_wq;
+	struct workqueue_struct *link_wq;
 
 	/* move out of interrupt context */
 	struct work_struct link_vc_work;
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 7f5e4c7..be027c9 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -660,6 +660,20 @@ static int create_workqueues(struct hfi1_devdata *dd)
 			if (!ppd->hfi1_wq)
 				goto wq_error;
 		}
+		if (!ppd->link_wq) {
+			/*
+			 * Make the link workqueue single-threaded to enforce
+			 * serialization.
+			 */
+			ppd->link_wq =
+				alloc_workqueue(
+				    "hfi_link_%d_%d",
+				    WQ_SYSFS | WQ_MEM_RECLAIM | WQ_UNBOUND,
+				    1, /* max_active */
+				    dd->unit, pidx);
+			if (!ppd->link_wq)
+				goto wq_error;
+		}
 	}
 	return 0;
 wq_error:
@@ -670,6 +684,10 @@ static int create_workqueues(struct hfi1_devdata *dd)
 			destroy_workqueue(ppd->hfi1_wq);
 			ppd->hfi1_wq = NULL;
 		}
+		if (ppd->link_wq) {
+			destroy_workqueue(ppd->link_wq);
+			ppd->link_wq = NULL;
+		}
 	}
 	return -ENOMEM;
 }
@@ -954,6 +972,10 @@ static void shutdown_device(struct hfi1_devdata *dd)
 			destroy_workqueue(ppd->hfi1_wq);
 			ppd->hfi1_wq = NULL;
 		}
+		if (ppd->link_wq) {
+			destroy_workqueue(ppd->link_wq);
+			ppd->link_wq = NULL;
+		}
 	}
 	sdma_exit(dd);
 }
@@ -1575,6 +1597,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				destroy_workqueue(ppd->hfi1_wq);
 				ppd->hfi1_wq = NULL;
 			}
+			if (ppd->link_wq) {
+				destroy_workqueue(ppd->link_wq);
+				ppd->link_wq = NULL;
+			}
 		}
 		if (!j)
 			hfi1_device_remove(dd);
diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index adb6a4d..7108a4b 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -1012,7 +1012,7 @@ static void sc_wait_for_packet_egress(struct send_context *sc, int pause)
 				   "%s: context %u(%u) timeout waiting for packets to egress, remaining count %u, bouncing link\n",
 				   __func__, sc->sw_index,
 				   sc->hw_context, (u32)reg);
-			queue_work(dd->pport->hfi1_wq,
+			queue_work(dd->pport->link_wq,
 				   &dd->pport->link_bounce_work);
 			break;
 		}
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 71b4258..6781bcd 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -325,7 +325,7 @@ static void sdma_wait_for_packet_egress(struct sdma_engine *sde,
 			/* timed out - bounce the link */
 			dd_dev_err(dd, "%s: engine %u timeout waiting for packets to egress, remaining count %u, bouncing link\n",
 				   __func__, sde->this_idx, (u32)reg);
-			queue_work(dd->pport->hfi1_wq,
+			queue_work(dd->pport->link_wq,
 				   &dd->pport->link_bounce_work);
 			break;
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
