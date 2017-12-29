From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3 for-next 6/6] RDMA/hns: Assign dest_qp when deregistering mr
Date: Fri, 29 Dec 2017 17:39:01 +0800
Message-ID: <1514540341-115107-7-git-send-email-oulijun@huawei.com>
References: <1514540341-115107-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1514540341-115107-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

It needs to create eight reserve QPs for resolving
a bug of hip06. When deregistering mr, it will issue
a rdma write for every reserve QPs.

When modify qp from init to rtr, it needs to set
the value of dest_qp_num. Otherwise, it will lead
an error of freeing mr.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
V1->V2:
- Fix the assginment method for attr_mask becasue
  it only needs to set IB_QP_DEST_QPN for attr_mask
  when modify qp from init to rtr state.

V1:
- The initial submit
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index 6100ace..881129c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -775,7 +775,7 @@ static int hns_roce_v1_rsv_lp_qp(struct hns_roce_dev *hr_dev)
 			goto create_lp_qp_failed;
 		}
 
-		ret = hr_dev->hw->modify_qp(&hr_qp->ibqp, &attr, attr_mask,
+		ret = hr_dev->hw->modify_qp(&hr_qp->ibqp, &attr, IB_QP_DEST_QPN,
 					    IB_QPS_INIT, IB_QPS_RTR);
 		if (ret) {
 			dev_err(dev, "modify qp failed(%d)!\n", ret);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
