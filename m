From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 04/19] IB/hns: Simplify function of pd alloc and qp alloc
Date: Tue, 20 Sep 2016 17:06:57 +0100
Message-ID: <20160920160712.1190216-5-salil.mehta@huawei.com>
References: <20160920160712.1190216-1-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160920160712.1190216-1-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Dongdong Huang <hdd.huang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hns_roce_pd_alloc and hns_roce_reserve_range_qp use unnecessary
transformation of parameters. This patch simplify these two
functions.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Dongdong Huang(Donald) <hdd.huang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_pd.c | 14 +-------------
 drivers/infiniband/hw/hns/hns_roce_qp.c | 10 +---------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 4109f74..0cd6132 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -35,19 +35,7 @@
 
 static int hns_roce_pd_alloc(struct hns_roce_dev *hr_dev, unsigned long *pdn)
 {
-	struct device *dev = &hr_dev->pdev->dev;
-	unsigned long pd_number;
-	int ret = 0;
-
-	ret = hns_roce_bitmap_alloc(&hr_dev->pd_bitmap, &pd_number);
-	if (ret == -1) {
-		dev_err(dev, "alloc pdn from pdbitmap failed\n");
-		return -ENOMEM;
-	}
-
-	*pdn = pd_number;
-
-	return 0;
+	return hns_roce_bitmap_alloc(&hr_dev->pd_bitmap, pdn);
 }
 
 static void hns_roce_pd_free(struct hns_roce_dev *hr_dev, unsigned long pdn)
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index dd94e41..73de1d3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -112,16 +112,8 @@ static int hns_roce_reserve_range_qp(struct hns_roce_dev *hr_dev, int cnt,
 				     int align, unsigned long *base)
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
-	int ret = 0;
-	unsigned long qpn;
-
-	ret = hns_roce_bitmap_alloc_range(&qp_table->bitmap, cnt, align, &qpn);
-	if (ret == -1)
-		return -ENOMEM;
 
-	*base = qpn;
-
-	return 0;
+	return hns_roce_bitmap_alloc_range(&qp_table->bitmap, cnt, align, base);
 }
 
 enum hns_roce_qp_state to_hns_roce_state(enum ib_qp_state state)
-- 
1.9.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
