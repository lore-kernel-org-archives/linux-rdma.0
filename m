From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/3] IB/mlx4: Bug fixes in mlx4_ib_resize_cq
Date: Thu, 29 Jan 2015 10:41:42 +0200
Message-ID: <1422520903-22007-3-git-send-email-ogerlitz@mellanox.com>
References: <1422520903-22007-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1422520903-22007-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

1. Before the entries alignment, we need to check that the entries doesn't
exceed the device's max cqe.

2. After the alignment, we need to make sure that the aligned number doesn't
exceed the max cqes+1. The additional cqe is used to denote that the resizing
operation has completed.

3. If the users asks to resize the CQ with entries less than the oustanding cqes
we should fail instead of returning 0.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index a3b70f6..cb63ecd 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -367,8 +367,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 	int err;
 
 	mutex_lock(&cq->resize_mutex);
-
-	if (entries < 1) {
+	if (entries < 1 || entries > dev->dev->caps.max_cqes) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -379,7 +378,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 		goto out;
 	}
 
-	if (entries > dev->dev->caps.max_cqes) {
+	if (entries > dev->dev->caps.max_cqes + 1) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -392,7 +391,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 		/* Can't be smaller than the number of outstanding CQEs */
 		outst_cqe = mlx4_ib_get_outstanding_cqes(cq);
 		if (entries < outst_cqe + 1) {
-			err = 0;
+			err = -EINVAL;
 			goto out;
 		}
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
