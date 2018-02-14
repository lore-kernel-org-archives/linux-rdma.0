From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v1] RDMA/hns: Replace __raw_write*(cpu_to_le*()) with LE write*()
Date: Wed, 14 Feb 2018 20:11:17 +0200
Message-ID: <20180214181117.36808-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

There is no need to repeat the semantics of writel() and similar.
Moreover sparse complains about this:

drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1690:22: expected unsigned long long val
drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1690:22: got restricted __le64 <noident>

Fixing this by replacing __raw_write*(cpu_to_le*()) calls by plain
write*() ones.

Note, write*() accessors are little endian by definition.

Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 8 ++++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index da13bd7c3ca9..47e1b6ac1e1a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1687,13 +1687,13 @@ static int hns_roce_v1_post_mbox(struct hns_roce_dev *hr_dev, u64 in_param,
 	roce_set_field(val, ROCEE_MB6_ROCEE_MB_TOKEN_M,
 		       ROCEE_MB6_ROCEE_MB_TOKEN_S, token);
 
-	__raw_writeq(cpu_to_le64(in_param), hcr + 0);
-	__raw_writeq(cpu_to_le64(out_param), hcr + 2);
-	__raw_writel(cpu_to_le32(in_modifier), hcr + 4);
+	writeq(in_param, hcr + 0);
+	writeq(out_param, hcr + 2);
+	writel(in_modifier, hcr + 4);
 	/* Memory barrier */
 	wmb();
 
-	__raw_writel(cpu_to_le32(val), hcr + 5);
+	writel(val, hcr + 5);
 
 	mmiowb();
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index db2ff352d75f..8f8a71d44844 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1228,14 +1228,14 @@ static int hns_roce_v2_post_mbox(struct hns_roce_dev *hr_dev, u64 in_param,
 	roce_set_field(val1, HNS_ROCE_VF_MB5_TOKEN_MASK,
 		       HNS_ROCE_VF_MB5_TOKEN_SHIFT, token);
 
-	__raw_writeq(cpu_to_le64(in_param), hcr + 0);
-	__raw_writeq(cpu_to_le64(out_param), hcr + 2);
+	writeq(in_param, hcr + 0);
+	writeq(out_param, hcr + 2);
 
 	/* Memory barrier */
 	wmb();
 
-	__raw_writel(cpu_to_le32(val0), hcr + 4);
-	__raw_writel(cpu_to_le32(val1), hcr + 5);
+	writel(val0, hcr + 4);
+	writel(val1, hcr + 5);
 
 	mmiowb();
 
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
