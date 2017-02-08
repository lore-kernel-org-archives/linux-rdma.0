From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 21/27] IB/hfi1: Modify logging frequency of DCC errors
Date: Wed, 08 Feb 2017 05:27:55 -0800
Message-ID: <20170208132754.16442.19138.stgit@scvm10.sc.intel.com>
References: <20170208132142.16442.69329.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208132142.16442.69329.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use rate-limit state to limit number of messages logged
to kernel message buffer for DCC errors. Add new macro
dd_dev_info_ratelimited for that propose. Replace all
dd_dev_info calls in handle_dcc_err function with
rate-limited version.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   20 +++++++++++---------
 drivers/infiniband/hw/hfi1/hfi.h  |    4 ++++
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ef72bc2..b9d491c 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -7827,7 +7827,8 @@ static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		}
 
 		/* just report this */
-		dd_dev_info(dd, "DCC Error: fmconfig error: %s\n", extra);
+		dd_dev_info_ratelimited(dd, "DCC Error: fmconfig error: %s\n",
+					extra);
 		reg &= ~DCC_ERR_FLG_FMCONFIG_ERR_SMASK;
 	}
 
@@ -7878,34 +7879,35 @@ static void handle_dcc_err(struct hfi1_devdata *dd, u32 unused, u64 reg)
 		}
 
 		/* just report this */
-		dd_dev_info(dd, "DCC Error: PortRcv error: %s\n", extra);
-		dd_dev_info(dd, "           hdr0 0x%llx, hdr1 0x%llx\n",
-			    hdr0, hdr1);
+		dd_dev_info_ratelimited(dd, "DCC Error: PortRcv error: %s\n"
+					"               hdr0 0x%llx, hdr1 0x%llx\n",
+					extra, hdr0, hdr1);
 
 		reg &= ~DCC_ERR_FLG_RCVPORT_ERR_SMASK;
 	}
 
 	if (reg & DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_UC_SMASK) {
 		/* informative only */
-		dd_dev_info(dd, "8051 access to LCB blocked\n");
+		dd_dev_info_ratelimited(dd, "8051 access to LCB blocked\n");
 		reg &= ~DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_UC_SMASK;
 	}
 	if (reg & DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_HOST_SMASK) {
 		/* informative only */
-		dd_dev_info(dd, "host access to LCB blocked\n");
+		dd_dev_info_ratelimited(dd, "host access to LCB blocked\n");
 		reg &= ~DCC_ERR_FLG_EN_CSR_ACCESS_BLOCKED_HOST_SMASK;
 	}
 
 	/* report any remaining errors */
 	if (reg)
-		dd_dev_info(dd, "DCC Error: %s\n",
-			    dcc_err_string(buf, sizeof(buf), reg));
+		dd_dev_info_ratelimited(dd, "DCC Error: %s\n",
+					dcc_err_string(buf, sizeof(buf), reg));
 
 	if (lcl_reason == 0)
 		lcl_reason = OPA_LINKDOWN_REASON_UNKNOWN;
 
 	if (do_bounce) {
-		dd_dev_info(dd, "%s: PortErrorAction bounce\n", __func__);
+		dd_dev_info_ratelimited(dd, "%s: PortErrorAction bounce\n",
+					__func__);
 		set_link_down_reason(ppd, lcl_reason, 0, lcl_reason);
 		queue_work(ppd->hfi1_wq, &ppd->link_bounce_work);
 	}
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 9c3be91..0808e3c 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1942,6 +1942,10 @@ static inline u64 hfi1_pkt_base_sdma_integrity(struct hfi1_devdata *dd)
 	dev_info(&(dd)->pcidev->dev, "%s: " fmt, \
 			get_unit_name((dd)->unit), ##__VA_ARGS__)
 
+#define dd_dev_info_ratelimited(dd, fmt, ...) \
+	dev_info_ratelimited(&(dd)->pcidev->dev, "%s: " fmt, \
+			get_unit_name((dd)->unit), ##__VA_ARGS__)
+
 #define dd_dev_dbg(dd, fmt, ...) \
 	dev_dbg(&(dd)->pcidev->dev, "%s: " fmt, \
 		get_unit_name((dd)->unit), ##__VA_ARGS__)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
