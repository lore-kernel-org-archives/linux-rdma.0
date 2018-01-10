From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V2 for-next 5/7] RDMA/hns: Assign zero for pkey_index of wc in hip08
Date: Wed, 10 Jan 2018 14:39:51 +0800
Message-ID: <1515566393-63888-6-git-send-email-oulijun@huawei.com>
References: <1515566393-63888-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515566393-63888-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Because pkey is fixed for hip08 RoCE, it needs to assign zero
for pkey_index of wc. otherwise, it will happen an error when
establishing connection by communication management mechanism.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yixian Liu <liuyixian-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Wei Hu (Xavier) <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
V2:
- No fixed

V1:
- The initial submit
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index cb3ac54..38fb4c7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1910,6 +1910,9 @@ static int hns_roce_v2_poll_one(struct hns_roce_cq *hr_cq,
 		wc->wc_flags |= (roce_get_bit(cqe->byte_32,
 					      V2_CQE_BYTE_32_GRH_S) ?
 					      IB_WC_GRH : 0);
+		wc->port_num = roce_get_field(cqe->byte_32,
+				V2_CQE_BYTE_32_PORTN_M, V2_CQE_BYTE_32_PORTN_S);
+		wc->pkey_index = 0;
 	}
 
 	return 0;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
