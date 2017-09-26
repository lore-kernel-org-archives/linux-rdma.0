From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 07/12] IB/hfi1: Remove unused link_default variable
Date: Tue, 26 Sep 2017 07:00:43 -0700
Message-ID: <20170926140042.15601.98853.stgit@scvm10.sc.intel.com>
References: <20170926135843.15601.95865.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170926135843.15601.95865.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

devdata->link_default is no longer variable

Maintain number of holes by moving dc_shutdown

Reviewed-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    6 ++----
 drivers/infiniband/hw/hfi1/hfi.h  |    6 +++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 0b45615..99425ce 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -9967,7 +9967,7 @@ int hfi1_get_ib_cfg(struct hfi1_pportdata *ppd, int which)
 		val = ppd->phy_error_threshold;
 		break;
 	case HFI1_IB_CFG_LINKDEFAULT: /* IB link default (sleep/poll) */
-		val = dd->link_default;
+		val = HLS_DEFAULT;
 		break;
 
 	case HFI1_IB_CFG_HRTBT: /* Heartbeat off/enable/auto */
@@ -10573,7 +10573,7 @@ int set_link_state(struct hfi1_pportdata *ppd, u32 state)
 
 	orig_new_state = state;
 	if (state == HLS_DN_DOWNDEF)
-		state = dd->link_default;
+		state = HLS_DEFAULT;
 
 	/* interpret poll -> poll as a link bounce */
 	poll_bounce = ppd->host_link_state == HLS_DN_POLL &&
@@ -14950,8 +14950,6 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		init_vl_arb_caches(ppd);
 	}
 
-	dd->link_default = HLS_DN_POLL;
-
 	/*
 	 * Do remaining PCIe setup and save PCIe values in dd.
 	 * Any error printing is already done by the init code.
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 0a64158..611eeba 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -535,6 +535,8 @@ static inline u8 hfi1_16B_bth_get_pad(struct ib_other_headers *ohdr)
 #define HLS_UP (HLS_UP_INIT | HLS_UP_ARMED | HLS_UP_ACTIVE)
 #define HLS_DOWN ~(HLS_UP)
 
+#define HLS_DEFAULT HLS_DN_POLL
+
 /* use this MTU size if none other is given */
 #define HFI1_DEFAULT_ACTIVE_MTU 10240
 /* use this MTU size as the default maximum */
@@ -1108,8 +1110,7 @@ struct hfi1_devdata {
 	u16 rcvegrbufsize_shift;
 	/* both sides of the PCIe link are gen3 capable */
 	u8 link_gen3_capable;
-	/* default link down value (poll/sleep) */
-	u8 link_default;
+	u8 dc_shutdown;
 	/* localbus width (1, 2,4,8,16,32) from config space  */
 	u32 lbus_width;
 	/* localbus speed in MHz */
@@ -1293,7 +1294,6 @@ struct hfi1_devdata {
 	u8 oui1;
 	u8 oui2;
 	u8 oui3;
-	u8 dc_shutdown;
 
 	/* Timer and counter used to detect RcvBufOvflCnt changes */
 	struct timer_list rcverr_timer;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
