From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/6] amso1100: convert to using idr_alloc_cyclic
Date: Wed, 27 Mar 2013 15:29:34 -0400
Message-ID: <1364412578-7462-3-git-send-email-jlayton@redhat.com>
References: <1364412578-7462-1-git-send-email-jlayton@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364412578-7462-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

(Note: compile-tested only)

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/infiniband/hw/amso1100/c2.h    | 1 -
 drivers/infiniband/hw/amso1100/c2_qp.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2.h b/drivers/infiniband/hw/amso1100/c2.h
index ba7a1208..d619d73 100644
--- a/drivers/infiniband/hw/amso1100/c2.h
+++ b/drivers/infiniband/hw/amso1100/c2.h
@@ -265,7 +265,6 @@ struct c2_pd_table {
 struct c2_qp_table {
 	struct idr idr;
 	spinlock_t lock;
-	int last;
 };
 
 struct c2_element {
diff --git a/drivers/infiniband/hw/amso1100/c2_qp.c b/drivers/infiniband/hw/amso1100/c2_qp.c
index 0ab826b..86708de 100644
--- a/drivers/infiniband/hw/amso1100/c2_qp.c
+++ b/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -385,8 +385,7 @@ static int c2_alloc_qpn(struct c2_dev *c2dev, struct c2_qp *qp)
 	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&c2dev->qp_table.lock);
 
-	ret = idr_alloc(&c2dev->qp_table.idr, qp, c2dev->qp_table.last++, 0,
-			GFP_NOWAIT);
+	ret = idr_alloc_cyclic(&c2dev->qp_table.idr, qp, 0, 0, GFP_NOWAIT);
 	if (ret >= 0)
 		qp->qpn = ret;
 
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
