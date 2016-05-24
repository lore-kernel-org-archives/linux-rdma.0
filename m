From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/10] IB/hfi1: Add a retry for the first-time QSFP access
Date: Tue, 24 May 2016 12:50:53 -0700
Message-ID: <20160524195052.19706.43009.stgit@scvm10.sc.intel.com>
References: <20160524194746.19706.42976.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524194746.19706.42976.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some QSFPs do not respond within the expected time, but later
appear fine.  Add a limited retry on the first access.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/qsfp.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/qsfp.c b/drivers/infiniband/hw/hfi1/qsfp.c
index 2441669..aa7ed23 100644
--- a/drivers/infiniband/hw/hfi1/qsfp.c
+++ b/drivers/infiniband/hw/hfi1/qsfp.c
@@ -362,6 +362,7 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 {
 	u32 target = ppd->dd->hfi1_id;
 	int ret;
+	int retry_count;
 	unsigned long flags;
 	u8 *cache = &cp->cache[0];
 
@@ -376,8 +377,23 @@ int refresh_qsfp_cache(struct hfi1_pportdata *ppd, struct qsfp_data *cp)
 		goto bail;
 	}
 
+	retry_count = 0;
+retry:
 	ret = qsfp_read(ppd, target, 0, cache, QSFP_PAGESIZE);
 	if (ret != QSFP_PAGESIZE) {
+		/*
+		 * This is the first QSFP access the driver makes.
+		 * Some QSFPs don't respond within the expected time,
+		 * but later appear fine.  Retry at 2s intervals for up
+		 * to 10s.
+		 */
+		if (ret < 0 && retry_count < 5) {
+			retry_count++;
+			dd_dev_info(ppd->dd, "%s: QSFP not responding, waiting and retrying %d\n",
+				    __func__, retry_count);
+			msleep(2000);
+			goto retry;
+		}
 		dd_dev_info(ppd->dd,
 			    "%s: Page 0 read failed, expected %d, got %d\n",
 			    __func__, QSFP_PAGESIZE, ret);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
