From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/7] IB/core: Fix qp_sec use after free access
Date: Sun, 24 Sep 2017 21:46:30 +0300
Message-ID: <20170924184635.31948-3-leon@kernel.org>
References: <20170924184635.31948-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924184635.31948-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When security_ib_alloc_security fails, qp->qp_sec memory is freed.
However ib_destroy_qp still tries to access this memory which result
in kernel crash. So its initialized to NULL to avoid such access.

Fixes: d291f1a65232 ("IB/core: Enforce PKey security on QPs")
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/security.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index 70ad19c4c73e..88bdafb297f5 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -432,8 +432,10 @@ int ib_create_qp_security(struct ib_qp *qp, struct ib_device *dev)
 	atomic_set(&qp->qp_sec->error_list_count, 0);
 	init_completion(&qp->qp_sec->error_complete);
 	ret = security_ib_alloc_security(&qp->qp_sec->security);
-	if (ret)
+	if (ret) {
 		kfree(qp->qp_sec);
+		qp->qp_sec = NULL;
+	}
 
 	return ret;
 }
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
