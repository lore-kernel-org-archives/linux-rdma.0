From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 02/21] IB/hfi1: Fix i2c resource reservation checks
Date: Tue, 12 Apr 2016 10:50:04 -0700
Message-ID: <20160412175003.24485.78967.stgit@scvm10.sc.intel.com>
References: <20160412174746.24485.92280.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412174746.24485.92280.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The i2c and qsfp read/write routines should check for the resource
reservation of the incoming argument target rather than the implicit
target of the hardware HFI.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qsfp.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index 9ed1963..ac03d80 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -96,7 +96,7 @@ int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 {
 	int ret;
 
-	if (!check_chip_resource(ppd->dd, qsfp_resource(ppd->dd), __func__))
+	if (!check_chip_resource(ppd->dd, i2c_target(target), __func__))
 		return -EACCES;
 
 	/* make sure the TWSI bus is in a sane state */
@@ -162,7 +162,7 @@ int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 {
 	int ret;
 
-	if (!check_chip_resource(ppd->dd, qsfp_resource(ppd->dd), __func__))
+	if (!check_chip_resource(ppd->dd, i2c_target(target), __func__))
 		return -EACCES;
 
 	/* make sure the TWSI bus is in a sane state */
@@ -192,7 +192,7 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	int ret;
 	u8 page;
 
-	if (!check_chip_resource(ppd->dd, qsfp_resource(ppd->dd), __func__))
+	if (!check_chip_resource(ppd->dd, i2c_target(target), __func__))
 		return -EACCES;
 
 	/* make sure the TWSI bus is in a sane state */
@@ -276,7 +276,7 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	int ret;
 	u8 page;
 
-	if (!check_chip_resource(ppd->dd, qsfp_resource(ppd->dd), __func__))
+	if (!check_chip_resource(ppd->dd, i2c_target(target), __func__))
 		return -EACCES;
 
 	/* make sure the TWSI bus is in a sane state */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
