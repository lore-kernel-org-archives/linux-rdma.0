From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/13] IB/hfi1: Adjust hardware buffering parameter
Date: Sun, 25 Sep 2016 07:42:01 -0700
Message-ID: <20160925144159.10261.85155.stgit@scvm10.sc.intel.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It was determined that 0x880 is a better value for hardware buffering,
use it.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c |    4 ++--
 drivers/infiniband/hw/hfi1/chip.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 26c5ee5..88394cd 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -13385,9 +13385,9 @@ static void init_rbufs(struct hfi1_devdata *dd)
 		/*
 		 * Give up after 1ms - maximum wait time.
 		 *
-		 * RBuf size is 148KiB.  Slowest possible is PCIe Gen1 x1 at
+		 * RBuf size is 136KiB.  Slowest possible is PCIe Gen1 x1 at
 		 * 250MB/s bandwidth.  Lower rate to 66% for overhead to get:
-		 *	148 KB / (66% * 250MB/s) = 920us
+		 *	136 KB / (66% * 250MB/s) = 844us
 		 */
 		if (count++ > 500) {
 			dd_dev_err(dd,
diff --git a/drivers/infiniband/hw/hfi1/chip.h b/drivers/infiniband/hw/hfi1/chip.h
index 92f2485..9234525 100644
--- a/drivers/infiniband/hw/hfi1/chip.h
+++ b/drivers/infiniband/hw/hfi1/chip.h
@@ -82,7 +82,7 @@
  */
 #define CM_VAU 3
 /* HFI link credit count, AKA receive buffer depth (RBUF_DEPTH) */
-#define CM_GLOBAL_CREDITS 0x940
+#define CM_GLOBAL_CREDITS 0x880
 /* Number of PKey entries in the HW */
 #define MAX_PKEY_VALUES 16
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
