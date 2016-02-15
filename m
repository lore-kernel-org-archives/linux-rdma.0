From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 12/21] staging/rdma/hfi1: Fix misspellings
Date: Sun, 14 Feb 2016 20:20:58 -0800
Message-ID: <20160215042055.351.75668.stgit@scvm10.sc.intel.com>
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

Fix misspelled word based on checkpatch check:
CHECK: 'ffoo' may be misspelled - perhaps 'foo'?

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c |    2 +-
 drivers/staging/rdma/hfi1/qsfp.c |    2 +-
 drivers/staging/rdma/hfi1/sdma.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 233958d..53e3273 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -8080,7 +8080,7 @@ static inline int check_packet_present(struct hfi1_ctxtdata *rcd)
  * Receive packet IRQ handler.  This routine expects to be on its own IRQ.
  * This routine will try to handle packets immediately (latency), but if
  * it finds too many, it will invoke the thread handler (bandwitdh).  The
- * chip receive interupt is *not* cleared down until this or the thread (if
+ * chip receive interrupt is *not* cleared down until this or the thread (if
  * invoked) is finished.  The intent is to avoid extra interrupts while we
  * are processing packets anyway.
  */
diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index aa9c62b..bdb1504 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -216,7 +216,7 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 
 	while (count < len) {
 		/*
-		 * Set the qsfp page based on a zero-based addresss
+		 * Set the qsfp page based on a zero-based address
 		 * and a page size of QSFP_PAGESIZE bytes.
 		 */
 		page = (u8)(addr / QSFP_PAGESIZE);
diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 2fbdb4d..59627b7 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -2740,7 +2740,7 @@ enomem:
  * This function calls _extend_sdma_tx_descs to extend or allocate
  * coalesce buffer. If there is a allocated coalesce buffer, it will
  * copy the input packet data into the coalesce buffer. It also adds
- * coalesce buffer descriptor once whe whole packet is received.
+ * coalesce buffer descriptor once when whole packet is received.
  *
  * Return:
  * <0 - error

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
