From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 11/11] {topost} RDMA/hns: Modify the usage of cmd_sn in hip08
Date: Fri, 10 Nov 2017 16:55:53 +0800
Message-ID: <1510304153-91394-12-git-send-email-oulijun@huawei.com>
References: <1510304153-91394-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510304153-91394-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The cmd_sn field of CQ doorbell inits for 0. It should be
increment on each first db rung after a complemention Event.
if the cmd_sn of notify doorbell Adjacent two times is the
same, the hardware will distinguish it for the same notify
request and update its type according to the priority level
of next event and solicited event.

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c     | 2 ++
 drivers/infiniband/hw/hns/hns_roce_device.h | 1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index f558f95..2111b57 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -156,6 +156,7 @@ static int hns_roce_cq_alloc(struct hns_roce_dev *hr_dev, int nent,
 	}
 
 	hr_cq->cons_index = 0;
+	hr_cq->arm_sn = 1;
 	hr_cq->uar = hr_uar;
 
 	atomic_set(&hr_cq->refcount, 1);
@@ -456,6 +457,7 @@ void hns_roce_cq_completion(struct hns_roce_dev *hr_dev, u32 cqn)
 		return;
 	}
 
+	++cq->arm_sn;
 	cq->comp(cq);
 }
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 724a5a0..01d3d69 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -347,6 +347,7 @@ struct hns_roce_cq {
 	u32				cons_index;
 	void __iomem			*cq_db_l;
 	u16				*tptr_addr;
+	int				arm_sn;
 	unsigned long			cqn;
 	u32				vector;
 	atomic_t			refcount;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 7008fa3..8f719c0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1440,7 +1440,7 @@ static int hns_roce_v2_req_notify_cq(struct ib_cq *ibcq,
 		       V2_CQ_DB_PARAMETER_CONS_IDX_S,
 		       hr_cq->cons_index & ((hr_cq->cq_depth << 1) - 1));
 	roce_set_field(doorbell[1], V2_CQ_DB_PARAMETER_CMD_SN_M,
-		       V2_CQ_DB_PARAMETER_CMD_SN_S, 1);
+		       V2_CQ_DB_PARAMETER_CMD_SN_S, hr_cq->arm_sn & 0x3);
 	roce_set_bit(doorbell[1], V2_CQ_DB_PARAMETER_NOTIFY_S,
 		     notification_flag);
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
