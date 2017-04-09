From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 18/20] IB/hfi1: Fix unbalanced braces around else
Date: Sun, 09 Apr 2017 10:17:18 -0700
Message-ID: <20170409171717.10579.36147.stgit@scvm10.sc.intel.com>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170409171329.10579.92775.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add missing braces around else blocks in a few places to make checkpatch
happy.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 ++--
 drivers/infiniband/hw/hfi1/init.c |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index c0cfcd1..19fab90 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -8147,10 +8147,10 @@ static irqreturn_t sdma_interrupt(int irq, void *data)
 
 		/* handle the interrupt(s) */
 		sdma_engine_interrupt(sde, status);
-	} else
+	} else {
 		dd_dev_err(dd, "SDMA engine %u interrupt, but no status bits set\n",
 			   sde->this_idx);
-
+	}
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
index 838d3a8..e9b33c8 100644
--- a/drivers/infiniband/hw/hfi1/init.c
+++ b/drivers/infiniband/hw/hfi1/init.c
@@ -245,9 +245,10 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 			if (ctxt < kctxt_ngroups) {
 				base = ctxt * (dd->rcv_entries.ngroups + 1);
 				rcd->rcv_array_groups++;
-			} else
+			} else {
 				base = kctxt_ngroups +
 					(ctxt * dd->rcv_entries.ngroups);
+			}
 		} else {
 			u16 ct = ctxt - dd->first_user_ctxt;
 
@@ -256,9 +257,10 @@ struct hfi1_ctxtdata *hfi1_create_ctxtdata(struct hfi1_pportdata *ppd, u32 ctxt,
 			if (ct < dd->rcv_entries.nctxt_extra) {
 				base += ct * (dd->rcv_entries.ngroups + 1);
 				rcd->rcv_array_groups++;
-			} else
+			} else {
 				base += dd->rcv_entries.nctxt_extra +
 					(ct * dd->rcv_entries.ngroups);
+			}
 		}
 		rcd->eager_base = base * dd->rcv_entries.group_size;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
