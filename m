From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 03/54] staging/rdma/hfi1: cleanup messages on qsfp_read()
 failure
Date: Wed, 03 Feb 2016 14:30:57 -0800
Message-ID: <20160203223054.5923.29599.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The ":" in "%s:" adds no value.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/qsfp.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qsfp.c b/drivers/staging/rdma/hfi1/qsfp.c
index 6326a91..6e9c56f 100644
--- a/drivers/staging/rdma/hfi1/qsfp.c
+++ b/drivers/staging/rdma/hfi1/qsfp.c
@@ -330,48 +330,48 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 			/* all */
 			ret = qsfp_read(ppd, target, 384, cache + 256, 128);
 			if (ret <= 0 || ret != 128) {
-				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				dd_dev_info(ppd->dd, "%s failed\n", __func__);
 				goto bail;
 			}
 			ret = qsfp_read(ppd, target, 640, cache + 384, 128);
 			if (ret <= 0 || ret != 128) {
-				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				dd_dev_info(ppd->dd, "%s failed\n", __func__);
 				goto bail;
 			}
 			ret = qsfp_read(ppd, target, 896, cache + 512, 128);
 			if (ret <= 0 || ret != 128) {
-				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				dd_dev_info(ppd->dd, "%s failed\n", __func__);
 				goto bail;
 			}
 		} else if ((cache[195] & 0x80) == 0x80) {
 			/* only page 2 and 3 */
 			ret = qsfp_read(ppd, target, 640, cache + 384, 128);
 			if (ret <= 0 || ret != 128) {
-				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				dd_dev_info(ppd->dd, "%s failed\n", __func__);
 				goto bail;
 			}
 			ret = qsfp_read(ppd, target, 896, cache + 512, 128);
 			if (ret <= 0 || ret != 128) {
-				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				dd_dev_info(ppd->dd, "%s failed\n", __func__);
 				goto bail;
 			}
 		} else if ((cache[195] & 0x40) == 0x40) {
 			/* only page 1 and 3 */
 			ret = qsfp_read(ppd, target, 384, cache + 256, 128);
 			if (ret <= 0 || ret != 128) {
-				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				dd_dev_info(ppd->dd, "%s failed\n", __func__);
 				goto bail;
 			}
 			ret = qsfp_read(ppd, target, 896, cache + 512, 128);
 			if (ret <= 0 || ret != 128) {
-				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				dd_dev_info(ppd->dd, "%s failed\n", __func__);
 				goto bail;
 			}
 		} else {
 			/* only page 3 */
 			ret = qsfp_read(ppd, target, 896, cache + 512, 128);
 			if (ret <= 0 || ret != 128) {
-				dd_dev_info(ppd->dd, "%s: failed\n", __func__);
+				dd_dev_info(ppd->dd, "%s failed\n", __func__);
 				goto bail;
 			}
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
