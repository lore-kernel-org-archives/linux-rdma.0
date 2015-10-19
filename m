From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 04/23] staging/rdma/hfi1: Implement time-out for send context halt recovery
Date: Mon, 19 Oct 2015 12:43:28 -0400
Message-ID: <1445273027-29634-5-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch increases the timout for packet egress to 500 us and timer
resets to zero if the packet occupancy changes. Also we bounce the link
on time out.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vennila Megavannan <vennila.megavannan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/pio.c  | 14 +++++++++++---
 drivers/staging/rdma/hfi1/sdma.c | 15 ++++++++++++---
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/pio.c b/drivers/staging/rdma/hfi1/pio.c
index 67dd93a6888c..e5c32db4bc67 100644
--- a/drivers/staging/rdma/hfi1/pio.c
+++ b/drivers/staging/rdma/hfi1/pio.c
@@ -922,10 +922,12 @@ void sc_disable(struct send_context *sc)
 static void sc_wait_for_packet_egress(struct send_context *sc, int pause)
 {
 	struct hfi1_devdata *dd = sc->dd;
-	u64 reg;
+	u64 reg = 0;
+	u64 reg_prev;
 	u32 loop = 0;
 
 	while (1) {
+		reg_prev = reg;
 		reg = read_csr(dd, sc->hw_context * 8 +
 			       SEND_EGRESS_CTXT_STATUS);
 		/* done if egress is stopped */
@@ -934,11 +936,17 @@ static void sc_wait_for_packet_egress(struct send_context *sc, int pause)
 		reg = packet_occupancy(reg);
 		if (reg == 0)
 			break;
-		if (loop > 100) {
+		/* counter is reset if occupancy count changes */
+		if (reg != reg_prev)
+			loop = 0;
+		if (loop > 500) {
+			/* timed out - bounce the link */
 			dd_dev_err(dd,
-				"%s: context %u(%u) timeout waiting for packets to egress, remaining count %u\n",
+				"%s: context %u(%u) timeout waiting for packets to egress, remaining count %u, bouncing link\n",
 				__func__, sc->sw_index,
 				sc->hw_context, (u32)reg);
+			queue_work(dd->pport->hfi1_wq,
+				&dd->pport->link_bounce_work);
 			break;
 		}
 		loop++;
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 63ab72102183..d57531796723 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -303,17 +303,26 @@ static void sdma_wait_for_packet_egress(struct sdma_engine *sde,
 	u64 off = 8 * sde->this_idx;
 	struct hfi1_devdata *dd = sde->dd;
 	int lcnt = 0;
+	u64 reg_prev;
+	u64 reg = 0;
 
 	while (1) {
-		u64 reg = read_csr(dd, off + SEND_EGRESS_SEND_DMA_STATUS);
+		reg_prev = reg;
+		reg = read_csr(dd, off + SEND_EGRESS_SEND_DMA_STATUS);
 
 		reg &= SDMA_EGRESS_PACKET_OCCUPANCY_SMASK;
 		reg >>= SDMA_EGRESS_PACKET_OCCUPANCY_SHIFT;
 		if (reg == 0)
 			break;
-		if (lcnt++ > 100) {
-			dd_dev_err(dd, "%s: engine %u timeout waiting for packets to egress, remaining count %u\n",
+		/* counter is reest if accupancy count changes */
+		if (reg != reg_prev)
+			lcnt = 0;
+		if (lcnt++ > 500) {
+			/* timed out - bounce the link */
+			dd_dev_err(dd, "%s: engine %u timeout waiting for packets to egress, remaining count %u, bouncing link\n",
 				  __func__, sde->this_idx, (u32)reg);
+			queue_work(dd->pport->hfi1_wq,
+				&dd->pport->link_bounce_work);
 			break;
 		}
 		udelay(1);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
