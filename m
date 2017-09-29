From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 6/8] RDMA/hns: Add return statement when checking error in hns_roce_v1_mr_free_work_fn
Date: Fri, 29 Sep 2017 23:10:12 +0800
Message-ID: <1506697814-98432-7-git-send-email-xavier.huwei@huawei.com>
References: <1506697814-98432-1-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1506697814-98432-1-git-send-email-xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lijun_nudt-9Onoh4P/yGk@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangxiping3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shaobohsu-9Onoh4P/yGk@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

After the loop in hns_roce_v1_mr_free_work_fn function, it is possible that
the local variable named hr_qp is NULL, the operation "hr_qp->qpn" will
result in the exception. As a result, we add return statement when checking
error.

This patch fixes the smatch error as below:
drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1009 hns_roce_v1_mr_free_work_fn()
error: we previously assumed 'hr_qp' could be null

Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index d82b4de..15e0f2e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -1004,6 +1004,11 @@ static void hns_roce_v1_mr_free_work_fn(struct work_struct *work)
 		}
 	}
 
+	if (!ne) {
+		dev_err(dev, "Reseved loop qp is absent!\n");
+		goto free_work;
+	}
+
 	do {
 		ret = hns_roce_v1_poll_cq(&mr_free_cq->ib_cq, ne, wc);
 		if (ret < 0) {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
