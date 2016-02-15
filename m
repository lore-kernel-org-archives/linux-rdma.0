From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/21] staging/rdma/hfi1: Use BIT_ULL macro
Date: Sun, 14 Feb 2016 20:20:42 -0800
Message-ID: <20160215042038.351.88108.stgit@scvm10.sc.intel.com>
References: <20160215041616.351.42119.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160215041616.351.42119.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use BIT_ULL macro to fix checkpatch check:
CHECK: Prefer using the BIT_ULL macro

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.h  |   16 ++++++++--------
 drivers/staging/rdma/hfi1/eprom.c |    2 +-
 drivers/staging/rdma/hfi1/sdma.h  |    8 ++++----
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 6c581e0..2b30aaa 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -93,15 +93,15 @@
 #define TXE_PIO_SEND (TXE + TXE_PIO_SEND_OFFSET)
 
 /* PBC flags */
-#define PBC_INTR		(1ull << 31)
+#define PBC_INTR		BIT_ULL(31)
 #define PBC_DC_INFO_SHIFT	(30)
-#define PBC_DC_INFO		(1ull << PBC_DC_INFO_SHIFT)
-#define PBC_TEST_EBP	(1ull << 29)
-#define PBC_PACKET_BYPASS	(1ull << 28)
-#define PBC_CREDIT_RETURN	(1ull << 25)
-#define PBC_INSERT_BYPASS_ICRC (1ull << 24)
-#define PBC_TEST_BAD_ICRC	(1ull << 23)
-#define PBC_FECN		(1ull << 22)
+#define PBC_DC_INFO		BIT_ULL(PBC_DC_INFO_SHIFT)
+#define PBC_TEST_EBP		BIT_ULL(29)
+#define PBC_PACKET_BYPASS	BIT_ULL(28)
+#define PBC_CREDIT_RETURN	BIT_ULL(25)
+#define PBC_INSERT_BYPASS_ICRC	BIT_ULL(24)
+#define PBC_TEST_BAD_ICRC	BIT_ULL(23)
+#define PBC_FECN		BIT_ULL(22)
 
 /* PbcInsertHcrc field settings */
 #define PBC_IHCRC_LKDETH 0x0	/* insert @ local KDETH offset */
diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index 9a0ddd7..d7250af 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -102,7 +102,7 @@
 #define COUNT_DELAY_SEC(n) ((n) * (1000000 / WAIT_SLEEP_US))
 
 /* GPIO pins */
-#define EPROM_WP_N (1ull << 14)	/* EPROM write line */
+#define EPROM_WP_N BIT_ULL(14)	/* EPROM write line */
 
 /*
  * Use the EP mutex to guard against other callers from within the driver.
diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index cc01e81..0ee22c4 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -107,8 +107,8 @@
 /*
  * Bits defined in the send DMA descriptor.
  */
-#define SDMA_DESC0_FIRST_DESC_FLAG      (1ULL << 63)
-#define SDMA_DESC0_LAST_DESC_FLAG       (1ULL << 62)
+#define SDMA_DESC0_FIRST_DESC_FLAG      BIT_ULL(63)
+#define SDMA_DESC0_LAST_DESC_FLAG       BIT_ULL(62)
 #define SDMA_DESC0_BYTE_COUNT_SHIFT     48
 #define SDMA_DESC0_BYTE_COUNT_WIDTH     14
 #define SDMA_DESC0_BYTE_COUNT_MASK \
@@ -152,8 +152,8 @@
 	((1ULL << SDMA_DESC1_GENERATION_WIDTH) - 1)
 #define SDMA_DESC1_GENERATION_SMASK \
 	(SDMA_DESC1_GENERATION_MASK << SDMA_DESC1_GENERATION_SHIFT)
-#define SDMA_DESC1_INT_REQ_FLAG         (1ULL << 1)
-#define SDMA_DESC1_HEAD_TO_HOST_FLAG    (1ULL << 0)
+#define SDMA_DESC1_INT_REQ_FLAG         BIT_ULL(1)
+#define SDMA_DESC1_HEAD_TO_HOST_FLAG    BIT_ULL(0)
 
 enum sdma_states {
 	sdma_state_s00_hw_down,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
