From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 11/17] IB/hfi1: Remove unused HFI1_DO_INIT_ASIC flag
Date: Sat, 05 Mar 2016 08:50:17 -0800
Message-ID: <20160305165016.32025.30027.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The flag HFI1_DO_INIT_ASIC flag is no longer used.  Remove
the flag and the code that sets it.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |   12 ------------
 drivers/infiniband/hw/hfi1/hfi.h  |    1 -
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 7170913..ac03452 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13815,11 +13815,6 @@ void hfi1_start_cleanup(struct hfi1_devdata *dd)
  * Information can be shared between the two HFIs on the same ASIC
  * in the same OS.  This function finds the peer device and sets
  * up a shared structure.
- *
- * Certain chip functions need to be initialized only once per asic
- * instead of per-device. This function finds the peer device and
- * checks whether that chip initialization needs to be done by this
- * device.
  */
 static int init_asic_data(struct hfi1_devdata *dd)
 {
@@ -13837,13 +13832,6 @@ static int init_asic_data(struct hfi1_devdata *dd)
 		}
 	}
 
-	/*
-	 * "Claim" the ASIC for initialization if it hasn't been
-	 " "claimed" yet.
-	 */
-	if (!peer || !(peer->flags & HFI1_DO_INIT_ASIC))
-		dd->flags |= HFI1_DO_INIT_ASIC;
-
 	if (peer) {
 		dd->asic_data = peer->asic_data;
 	} else {
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 108015c..035a151 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1602,7 +1602,6 @@ static inline struct cc_state *get_cc_state(struct hfi1_pportdata *ppd)
 #define HFI1_HAS_SDMA_TIMEOUT  0x8
 #define HFI1_HAS_SEND_DMA      0x10   /* Supports Send DMA */
 #define HFI1_FORCED_FREEZE     0x80   /* driver forced freeze mode */
-#define HFI1_DO_INIT_ASIC      0x100  /* This device will init the ASIC */
 
 /* IB dword length mask in PBC (lower 11 bits); same for all chips */
 #define HFI1_PBC_LENGTH_MASK                     ((1 << 11) - 1)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
