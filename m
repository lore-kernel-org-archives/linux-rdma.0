From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 41/77] IB/cxgb4: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:13 -0800
Message-ID: <1360179649-22465-42-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 9c1644f..7f862da 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -260,20 +260,21 @@ static inline int _insert_handle(struct c4iw_dev *rhp, struct idr *idr,
 				 void *handle, u32 id, int lock)
 {
 	int ret;
-	int newid;
 
-	do {
-		if (!idr_pre_get(idr, lock ? GFP_KERNEL : GFP_ATOMIC))
-			return -ENOMEM;
-		if (lock)
-			spin_lock_irq(&rhp->lock);
-		ret = idr_get_new_above(idr, handle, id, &newid);
-		BUG_ON(!ret && newid != id);
-		if (lock)
-			spin_unlock_irq(&rhp->lock);
-	} while (ret == -EAGAIN);
-
-	return ret;
+	if (lock) {
+		idr_preload(GFP_KERNEL);
+		spin_lock_irq(&rhp->lock);
+	}
+
+	ret = idr_alloc(idr, handle, id, id + 1, GFP_ATOMIC);
+
+	if (lock) {
+		spin_unlock_irq(&rhp->lock);
+		idr_preload_end();
+	}
+
+	BUG_ON(ret == -ENOSPC);
+	return ret < 0 ? ret : 0;
 }
 
 static inline int insert_handle(struct c4iw_dev *rhp, struct idr *idr,
-- 
1.8.1
