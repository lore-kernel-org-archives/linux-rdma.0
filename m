From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/4] RDMA/hns: Remove unnecessary operator
Date: Tue, 30 Jan 2018 20:20:43 +0800
Message-ID: <1517314845-126094-3-git-send-email-oulijun@huawei.com>
References: <1517314845-126094-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517314845-126094-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The double Non-operator is unncessary when used
in a boolean context. This patch remove them.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 605202d..036262a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2148,10 +2148,10 @@ static void set_access_flags(struct hns_roce_qp *hr_qp,
 	u8 dest_rd_atomic;
 	u32 access_flags;
 
-	dest_rd_atomic = !!(attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) ?
+	dest_rd_atomic = (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC) ?
 			 attr->max_dest_rd_atomic : hr_qp->resp_depth;
 
-	access_flags = !!(attr_mask & IB_QP_ACCESS_FLAGS) ?
+	access_flags = (attr_mask & IB_QP_ACCESS_FLAGS) ?
 		       attr->qp_access_flags : hr_qp->atomic_rd_en;
 
 	if (!dest_rd_atomic)
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
