From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 6/6] RDMA/hns: Assign dest_qp when deregistering mr
Date: Tue, 26 Dec 2017 19:25:14 +0800
Message-ID: <1514287514-88723-7-git-send-email-oulijun@huawei.com>
References: <1514287514-88723-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514287514-88723-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It needs to create eight reserve QPs for resolving
a bug of hip06. When deregistering mr, it will issue
a rdma write for every reserve QPs.

In the above process, it needs to assign dest_qp.
Otherwise, it will trigger free mr work fail.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 6100ace..490a1fc 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -775,6 +775,7 @@ static int hns_roce_v1_rsv_lp_qp(struct hns_roce_dev *hr_dev)
 			goto create_lp_qp_failed;
 		}
 
+		attr_mask |= IB_QP_DEST_QPN;
 		ret = hr_dev->hw->modify_qp(&hr_qp->ibqp, &attr, attr_mask,
 					    IB_QPS_INIT, IB_QPS_RTR);
 		if (ret) {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
