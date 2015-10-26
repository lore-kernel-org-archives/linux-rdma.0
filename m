From: ira.weiny@intel.com
Subject: [PATCH v3 04/23] staging/rdma/hfi1: Prevent host software lock up
Date: Mon, 26 Oct 2015 10:28:30 -0400
Message-ID: <1445869729-7507-5-git-send-email-ira.weiny@intel.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, dledford@redhat.com, Vennila Megavannan <vennila.megavannan@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Vennila Megavannan <vennila.megavannan@intel.com>

If packets stop egressing the hardware link, software can lock up.

Implement a timeout for send context halt recovery.  This patch increases the
timeout for packet egress to 500 us and timer resets to zero if the packet
occupancy changes. Also we bounce the link on time out.

Reviewed-by: Dean Luick <dean.luick@intel.com>
Signed-off-by: Vennila Megavannan <vennila.megavannan@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
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
