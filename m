From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 4/4] IB/core: Verify that QP is security enabled in create and destroy
Date: Sun, 24 Dec 2017 13:54:58 +0200
Message-ID: <20171224115458.27577-5-leon@kernel.org>
References: <20171224115458.27577-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224115458.27577-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The XRC target QP create flow it does some security related work.
However, security is enable only when link layer is InfiniBand so before
doing this work the driver should check if security context is initialized.
The same applies for destroy flow.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.12
Fixes: d291f1a65232 ("IB/core: Enforce PKey security on QPs")
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/security.c | 3 +++
 drivers/infiniband/core/verbs.c    | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
index feafdb961c48..59b2f96d986a 100644
--- a/drivers/infiniband/core/security.c
+++ b/drivers/infiniband/core/security.c
@@ -386,6 +386,9 @@ int ib_open_shared_qp_security(struct ib_qp *qp, struct ib_device *dev)
 	if (ret)
 		return ret;
 
+	if (!qp->qp_sec)
+		return 0;
+
 	mutex_lock(&real_qp->qp_sec->mutex);
 	ret = check_qp_port_pkey_settings(real_qp->qp_sec->ports_pkeys,
 					  qp->qp_sec);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 3fb8fb6cc824..e36d27ed4daa 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1438,7 +1438,8 @@ int ib_close_qp(struct ib_qp *qp)
 	spin_unlock_irqrestore(&real_qp->device->event_handler_lock, flags);
 
 	atomic_dec(&real_qp->usecnt);
-	ib_close_shared_qp_security(qp->qp_sec);
+	if (qp->qp_sec)
+		ib_close_shared_qp_security(qp->qp_sec);
 	kfree(qp);
 
 	return 0;
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
