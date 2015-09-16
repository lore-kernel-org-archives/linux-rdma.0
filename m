From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] IB/hfi1: clean up some defines
Date: Wed, 16 Sep 2015 19:02:54 +0300
Message-ID: <20150916160254.GD9735@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

I added spaces around operators so it matches kernel style because
normally "-1ULL" is a number and " - 1" is a subtract operation.  Also
removed some superflous "ULL" types so "1ULL" becomes "1".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/rdma/hfi1/sdma.h b/drivers/staging/rdma/hfi1/sdma.h
index 1e613fc..4960869 100644
--- a/drivers/staging/rdma/hfi1/sdma.h
+++ b/drivers/staging/rdma/hfi1/sdma.h
@@ -109,53 +109,53 @@
 /*
  * Bits defined in the send DMA descriptor.
  */
-#define SDMA_DESC0_FIRST_DESC_FLAG      (1ULL<<63)
-#define SDMA_DESC0_LAST_DESC_FLAG       (1ULL<<62)
+#define SDMA_DESC0_FIRST_DESC_FLAG      (1ULL << 63)
+#define SDMA_DESC0_LAST_DESC_FLAG       (1ULL << 62)
 #define SDMA_DESC0_BYTE_COUNT_SHIFT     48
 #define SDMA_DESC0_BYTE_COUNT_WIDTH     14
 #define SDMA_DESC0_BYTE_COUNT_MASK \
-	((1ULL<<SDMA_DESC0_BYTE_COUNT_WIDTH)-1ULL)
+	((1ULL << SDMA_DESC0_BYTE_COUNT_WIDTH) - 1)
 #define SDMA_DESC0_BYTE_COUNT_SMASK \
-	(SDMA_DESC0_BYTE_COUNT_MASK<<SDMA_DESC0_BYTE_COUNT_SHIFT)
+	(SDMA_DESC0_BYTE_COUNT_MASK << SDMA_DESC0_BYTE_COUNT_SHIFT)
 #define SDMA_DESC0_PHY_ADDR_SHIFT       0
 #define SDMA_DESC0_PHY_ADDR_WIDTH       48
 #define SDMA_DESC0_PHY_ADDR_MASK \
-	((1ULL<<SDMA_DESC0_PHY_ADDR_WIDTH)-1ULL)
+	((1ULL << SDMA_DESC0_PHY_ADDR_WIDTH) - 1)
 #define SDMA_DESC0_PHY_ADDR_SMASK \
-	(SDMA_DESC0_PHY_ADDR_MASK<<SDMA_DESC0_PHY_ADDR_SHIFT)
+	(SDMA_DESC0_PHY_ADDR_MASK << SDMA_DESC0_PHY_ADDR_SHIFT)
 
 #define SDMA_DESC1_HEADER_UPDATE1_SHIFT 32
 #define SDMA_DESC1_HEADER_UPDATE1_WIDTH 32
 #define SDMA_DESC1_HEADER_UPDATE1_MASK \
-	((1ULL<<SDMA_DESC1_HEADER_UPDATE1_WIDTH)-1ULL)
+	((1ULL << SDMA_DESC1_HEADER_UPDATE1_WIDTH) - 1)
 #define SDMA_DESC1_HEADER_UPDATE1_SMASK \
-	(SDMA_DESC1_HEADER_UPDATE1_MASK<<SDMA_DESC1_HEADER_UPDATE1_SHIFT)
+	(SDMA_DESC1_HEADER_UPDATE1_MASK << SDMA_DESC1_HEADER_UPDATE1_SHIFT)
 #define SDMA_DESC1_HEADER_MODE_SHIFT    13
 #define SDMA_DESC1_HEADER_MODE_WIDTH    3
 #define SDMA_DESC1_HEADER_MODE_MASK \
-	((1ULL<<SDMA_DESC1_HEADER_MODE_WIDTH)-1ULL)
+	((1ULL << SDMA_DESC1_HEADER_MODE_WIDTH) - 1)
 #define SDMA_DESC1_HEADER_MODE_SMASK \
-	(SDMA_DESC1_HEADER_MODE_MASK<<SDMA_DESC1_HEADER_MODE_SHIFT)
+	(SDMA_DESC1_HEADER_MODE_MASK << SDMA_DESC1_HEADER_MODE_SHIFT)
 #define SDMA_DESC1_HEADER_INDEX_SHIFT   8
 #define SDMA_DESC1_HEADER_INDEX_WIDTH   5
 #define SDMA_DESC1_HEADER_INDEX_MASK \
-	((1ULL<<SDMA_DESC1_HEADER_INDEX_WIDTH)-1ULL)
+	((1ULL << SDMA_DESC1_HEADER_INDEX_WIDTH) - 1)
 #define SDMA_DESC1_HEADER_INDEX_SMASK \
-	(SDMA_DESC1_HEADER_INDEX_MASK<<SDMA_DESC1_HEADER_INDEX_SHIFT)
+	(SDMA_DESC1_HEADER_INDEX_MASK << SDMA_DESC1_HEADER_INDEX_SHIFT)
 #define SDMA_DESC1_HEADER_DWS_SHIFT     4
 #define SDMA_DESC1_HEADER_DWS_WIDTH     4
 #define SDMA_DESC1_HEADER_DWS_MASK \
-	((1ULL<<SDMA_DESC1_HEADER_DWS_WIDTH)-1ULL)
+	((1ULL << SDMA_DESC1_HEADER_DWS_WIDTH) - 1)
 #define SDMA_DESC1_HEADER_DWS_SMASK \
-	(SDMA_DESC1_HEADER_DWS_MASK<<SDMA_DESC1_HEADER_DWS_SHIFT)
+	(SDMA_DESC1_HEADER_DWS_MASK << SDMA_DESC1_HEADER_DWS_SHIFT)
 #define SDMA_DESC1_GENERATION_SHIFT     2
 #define SDMA_DESC1_GENERATION_WIDTH     2
 #define SDMA_DESC1_GENERATION_MASK \
-	((1ULL<<SDMA_DESC1_GENERATION_WIDTH)-1ULL)
+	((1ULL << SDMA_DESC1_GENERATION_WIDTH) - 1)
 #define SDMA_DESC1_GENERATION_SMASK \
-	(SDMA_DESC1_GENERATION_MASK<<SDMA_DESC1_GENERATION_SHIFT)
-#define SDMA_DESC1_INT_REQ_FLAG         (1ULL<<1)
-#define SDMA_DESC1_HEAD_TO_HOST_FLAG    (1ULL<<0)
+	(SDMA_DESC1_GENERATION_MASK << SDMA_DESC1_GENERATION_SHIFT)
+#define SDMA_DESC1_INT_REQ_FLAG         (1ULL << 1)
+#define SDMA_DESC1_HEAD_TO_HOST_FLAG    (1ULL << 0)
 
 enum sdma_states {
 	sdma_state_s00_hw_down,
