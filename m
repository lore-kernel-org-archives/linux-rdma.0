From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 35/54] staging/rdma/hfi1: Report physical state changes per
 device instead of globally
Date: Wed, 03 Feb 2016 14:35:31 -0800
Message-ID: <20160203223528.5923.55030.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Make physical state change reporting be per-device, not global
to reduce excessive reports of "physical state changed"

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    6 +++---
 drivers/staging/rdma/hfi1/hfi.h  |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index a67483e..5b8fb02 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -12201,18 +12201,17 @@ static int wait_logical_linkstate(struct hfi1_pportdata *ppd, u32 state,
 
 u8 hfi1_ibphys_portstate(struct hfi1_pportdata *ppd)
 {
-	static u32 remembered_state = 0xff;
 	u32 pstate;
 	u32 ib_pstate;
 
 	pstate = read_physical_state(ppd->dd);
 	ib_pstate = chip_to_opa_pstate(ppd->dd, pstate);
-	if (remembered_state != ib_pstate) {
+	if (ppd->last_pstate != ib_pstate) {
 		dd_dev_info(ppd->dd,
 			"%s: physical state changed to %s (0x%x), phy 0x%x\n",
 			__func__, opa_pstate_name(ib_pstate), ib_pstate,
 			pstate);
-		remembered_state = ib_pstate;
+		ppd->last_pstate = ib_pstate;
 	}
 	return ib_pstate;
 }
@@ -14019,6 +14018,7 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 		/* start in offline */
 		ppd->host_link_state = HLS_DN_OFFLINE;
 		init_vl_arb_caches(ppd);
+		ppd->last_pstate = 0xff; /* invalid value */
 	}
 
 	dd->link_default = HLS_DN_POLL;
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index f3c1e67..da42991 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -663,6 +663,7 @@ struct hfi1_pportdata {
 	u8 link_enabled;	/* link enabled? */
 	u8 linkinit_reason;
 	u8 local_tx_rate;	/* rate given to 8051 firmware */
+	u8 last_pstate;		/* info only */
 
 	/* placeholders for IB MAD packet settings */
 	u8 overrun_threshold;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
