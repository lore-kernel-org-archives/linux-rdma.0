From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Add CSRs for CONFIG_SDMA_VERBOSITY
Date: Wed, 02 Sep 2015 10:43:24 -0400
Message-ID: <20150902144324.29183.67166.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

3 CSRs needed by the CONFIG_SDMA_VERBOSITY code were removed during
the CSR clean up. Adding these CSRs back to resolve 0-day build failure:
https://lists.01.org/pipermail/kbuild-all/2015-August/011919.html

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip_registers.h |    3 +++
 drivers/staging/rdma/hfi1/sdma.c           |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip_registers.h b/drivers/staging/rdma/hfi1/chip_registers.h
index 6521030..bf45de2 100644
--- a/drivers/staging/rdma/hfi1/chip_registers.h
+++ b/drivers/staging/rdma/hfi1/chip_registers.h
@@ -1285,5 +1285,8 @@
 #define PCIE_CFG_REG_PL106_GEN3_EQ_PSET_REQ_VEC_SHIFT 8
 #define PCIE_CFG_REG_PL106_GEN3_EQ_EVAL2MS_DISABLE_SMASK 0x20ull
 #define PCIE_CFG_REG_PL106_GEN3_EQ_PHASE23_EXIT_MODE_SMASK 0x10ull
+#define CCE_INT_BLOCKED (CCE + 0x000000110C00)
+#define SEND_DMA_IDLE_CNT (TXE + 0x000000200040)
+#define SEND_DMA_DESC_FETCHED_CNT (TXE + 0x000000200058)
 
 #endif          /* DEF_CHIP_REG */
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 37bd767..a8c903c 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -1769,7 +1769,7 @@ void sdma_dumpstate(struct sdma_engine *sde)
 	sdma_dumpstate_helper(SD(ENG_ERR_MASK));
 
 	for (i = 0; i < CCE_NUM_INT_CSRS; ++i) {
-		sdma_dumpstate_helper2(CCE_INT_STATUS));
+		sdma_dumpstate_helper2(CCE_INT_STATUS);
 		sdma_dumpstate_helper2(CCE_INT_MASK);
 		sdma_dumpstate_helper2(CCE_INT_BLOCKED);
 	}
@@ -1777,7 +1777,7 @@ void sdma_dumpstate(struct sdma_engine *sde)
 	sdma_dumpstate_helper(SD(TAIL));
 	sdma_dumpstate_helper(SD(HEAD));
 	sdma_dumpstate_helper(SD(PRIORITY_THLD));
-	sdma_dumpstate_helper(SD(IDLE_CNT);
+	sdma_dumpstate_helper(SD(IDLE_CNT));
 	sdma_dumpstate_helper(SD(RELOAD_CNT));
 	sdma_dumpstate_helper(SD(DESC_CNT));
 	sdma_dumpstate_helper(SD(DESC_FETCHED_CNT));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
