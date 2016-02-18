From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/8] staging/rdma/hfi1: Disclose more information when i2c
 fails
Date: Thu, 18 Feb 2016 11:12:34 -0800
Message-ID: <20160218191230.20983.38523.stgit@scvm10.sc.intel.com>
References: <20160218191005.20983.64127.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218191005.20983.64127.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Improve logging messages when there are i2c failures.
Clean i2c read error handling.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qsfp.c |   42 ++++++++++++++++++--------------------
 1 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index 07330b0..7e76b93 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -102,7 +102,8 @@ int i2c_write(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	ret = hfi1_twsi_reset(ppd->dd, target);
 	if (ret) {
 		hfi1_dev_porterr(ppd->dd, ppd->port,
-				 "I2C write interface reset failed\n");
+				 "I2C chain %d write interface reset failed\n",
+				 target);
 		goto done;
 	}
 
@@ -121,15 +122,14 @@ static int __i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
 {
 	struct hfi1_devdata *dd = ppd->dd;
 	int ret, cnt, pass = 0;
-	int stuck = 0;
-	u8 *buff = bp;
+	int orig_offset = offset;
 
 	cnt = 0;
 	while (cnt < len) {
 		int rlen = len - cnt;
 
 		ret = hfi1_twsi_blk_rd(dd, target, i2c_addr, offset,
-				       buff + cnt, rlen);
+				       bp + cnt, rlen);
 		/* Some QSFP's fail first try. Retry as experiment */
 		if (ret && cnt == 0 && ++pass < I2C_MAX_RETRY)
 			continue;
@@ -145,14 +145,11 @@ static int __i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr,
 	ret = cnt;
 
 exit:
-	if (stuck)
-		dd_dev_err(dd, "I2C interface bus stuck non-idle\n");
-
-	if (pass >= I2C_MAX_RETRY && ret)
+	if (ret < 0) {
 		hfi1_dev_porterr(dd, ppd->port,
-				 "I2C failed even retrying\n");
-	else if (pass)
-		hfi1_dev_porterr(dd, ppd->port, "I2C retries: %d\n", pass);
+				 "I2C chain %d read failed, addr 0x%x, offset 0x%x, len %d\n",
+				 target, i2c_addr, orig_offset, len);
+	}
 
 	/* Must wait min 20us between qsfp i2c transactions */
 	udelay(20);
@@ -174,7 +171,8 @@ int i2c_read(struct hfi1_pportdata *ppd, u32 target, int i2c_addr, int offset,
 	ret = hfi1_twsi_reset(ppd->dd, target);
 	if (ret) {
 		hfi1_dev_porterr(ppd->dd, ppd->port,
-				 "I2C read interface reset failed\n");
+				 "I2C chain %d read interface reset failed\n",
+				 target);
 		goto done;
 	}
 
@@ -206,7 +204,8 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	ret = hfi1_twsi_reset(ppd->dd, target);
 	if (ret) {
 		hfi1_dev_porterr(ppd->dd, ppd->port,
-				 "QSFP write interface reset failed\n");
+				 "QSFP chain %d write interface reset failed\n",
+				 target);
 		mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
 		return ret;
 	}
@@ -221,10 +220,9 @@ int qsfp_write(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		ret = __i2c_write(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
 				  QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
 		if (ret != 1) {
-			hfi1_dev_porterr(
-			ppd->dd,
-			ppd->port,
-			"can't write QSFP_PAGE_SELECT_BYTE: %d\n", ret);
+			hfi1_dev_porterr(ppd->dd, ppd->port,
+					 "QSFP chain %d can't write QSFP_PAGE_SELECT_BYTE: %d\n",
+					 target, ret);
 			ret = -EIO;
 			break;
 		}
@@ -272,7 +270,8 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 	ret = hfi1_twsi_reset(ppd->dd, target);
 	if (ret) {
 		hfi1_dev_porterr(ppd->dd, ppd->port,
-				 "QSFP read interface reset failed\n");
+				 "QSFP chain %d read interface reset failed\n",
+				 target);
 		mutex_unlock(&ppd->dd->qsfp_i2c_mutex);
 		return ret;
 	}
@@ -286,10 +285,9 @@ int qsfp_read(struct hfi1_pportdata *ppd, u32 target, int addr, void *bp,
 		ret = __i2c_write(ppd, target, QSFP_DEV | QSFP_OFFSET_SIZE,
 				  QSFP_PAGE_SELECT_BYTE_OFFS, &page, 1);
 		if (ret != 1) {
-			hfi1_dev_porterr(
-			ppd->dd,
-			ppd->port,
-			"can't write QSFP_PAGE_SELECT_BYTE: %d\n", ret);
+			hfi1_dev_porterr(ppd->dd, ppd->port,
+					 "QSFP chain %d can't write QSFP_PAGE_SELECT_BYTE: %d\n",
+					 target, ret);
 			ret = -EIO;
 			break;
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
