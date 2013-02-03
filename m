From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/62] infiniband/amso1100: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:24 -0800
Message-ID: <1359854463-2538-24-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk, Tejun Heo <tj@kernel.org>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Tom Tucker <tom@opengridcomputing.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: linux-rdma@vger.kernel.org
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/infiniband/hw/amso1100/c2_qp.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/infiniband/hw/amso1100/c2_qp.c
index 28cd5cb..0ab826b 100644
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -382,14 +382,17 @@ static int c2_alloc_qpn(struct c2_dev *c2dev, struct c2_qp *qp)
 {
 	int ret;
 
-        do {
-		spin_lock_irq(&c2dev->qp_table.lock);
-		ret = idr_get_new_above(&c2dev->qp_table.idr, qp,
-					c2dev->qp_table.last++, &qp->qpn);
-		spin_unlock_irq(&c2dev->qp_table.lock);
-        } while ((ret == -EAGAIN) &&
-	 	 idr_pre_get(&c2dev->qp_table.idr, GFP_KERNEL));
-	return ret;
+	idr_preload(GFP_KERNEL);
+	spin_lock_irq(&c2dev->qp_table.lock);
+
+	ret = idr_alloc(&c2dev->qp_table.idr, qp, c2dev->qp_table.last++, 0,
+			GFP_NOWAIT);
+	if (ret >= 0)
+		qp->qpn = ret;
+
+	spin_unlock_irq(&c2dev->qp_table.lock);
+	idr_preload_end();
+	return ret < 0 ? ret : 0;
 }
 
 static void c2_free_qpn(struct c2_dev *c2dev, int qpn)
-- 
1.8.1
