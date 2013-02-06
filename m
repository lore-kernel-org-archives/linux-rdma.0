From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 40/77] IB/cxgb3: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:12 -0800
Message-ID: <1360179649-22465-41-git-send-email-tj@kernel.org>
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
 drivers/infiniband/hw/cxgb3/iwch.h | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch.h b/drivers/infiniband/hw/cxgb3/iwch.h
index a1c4457..8378622 100644
--- a/drivers/infiniband/hw/cxgb3/iwch.h
+++ b/drivers/infiniband/hw/cxgb3/iwch.h
@@ -153,19 +153,17 @@ static inline int insert_handle(struct iwch_dev *rhp, struct idr *idr,
 				void *handle, u32 id)
 {
 	int ret;
-	int newid;
-
-	do {
-		if (!idr_pre_get(idr, GFP_KERNEL)) {
-			return -ENOMEM;
-		}
-		spin_lock_irq(&rhp->lock);
-		ret = idr_get_new_above(idr, handle, id, &newid);
-		BUG_ON(newid != id);
-		spin_unlock_irq(&rhp->lock);
-	} while (ret == -EAGAIN);
-
-	return ret;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock_irq(&rhp->lock);
+
+	ret = idr_alloc(idr, handle, id, id + 1, GFP_NOWAIT);
+
+	spin_unlock_irq(&rhp->lock);
+	idr_preload_end();
+
+	BUG_ON(ret == -ENOSPC);
+	return ret < 0 ? ret : 0;
 }
 
 static inline void remove_handle(struct iwch_dev *rhp, struct idr *idr, u32 id)
-- 
1.8.1
