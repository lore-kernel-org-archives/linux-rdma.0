From: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 3/4] RDMA/hns: Fix the checkpatch.pl warning
Date: Tue, 30 Jan 2018 20:20:44 +0800
Message-ID: <1517314845-126094-4-git-send-email-oulijun@huawei.com>
References: <1517314845-126094-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517314845-126094-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch mainly fix some style warings matched with
the new checkpatch requirement. The warning as follows:

WARNING: function definition argument 'struct hns_roce_cq *'
should also have an identifier name

Signed-off-by: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 2503d7f..165a09b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -345,8 +345,8 @@ struct hns_roce_cq {
 	struct hns_roce_cq_buf		hr_buf;
 	spinlock_t			lock;
 	struct ib_umem			*umem;
-	void (*comp)(struct hns_roce_cq *);
-	void (*event)(struct hns_roce_cq *, enum hns_roce_event);
+	void (*comp)(struct hns_roce_cq *cq);
+	void (*event)(struct hns_roce_cq *cq, enum hns_roce_event event_type);
 
 	struct hns_roce_uar		*uar;
 	u32				cq_depth;
@@ -486,8 +486,8 @@ struct hns_roce_qp {
 	u32                     atomic_rd_en;
 	u32			pkey_index;
 	u32			qkey;
-	void			(*event)(struct hns_roce_qp *,
-					 enum hns_roce_event);
+	void			(*event)(struct hns_roce_qp *qp,
+					 enum hns_roce_event event_type);
 	unsigned long		qpn;
 
 	atomic_t		refcount;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
