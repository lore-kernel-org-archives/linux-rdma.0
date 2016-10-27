From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 5/6] IB/core: Save QP in ib_flow structure
Date: Thu, 27 Oct 2016 16:36:30 +0300
Message-ID: <1477575391-20134-6-git-send-email-leon@kernel.org>
References: <1477575391-20134-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477575391-20134-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When we create flow steering rule, we need to save the related QP in the
ib_flow struct. this QP is used in destroy flow.

Move the QP assignment from ib_uverbs_ex_create_flow into ib_create_flow,
this would allow both kernel and userspace consumers to use it.

This bug wasn't seen in the wild because there are no kernel consumers
currently in the kernel.

Fixes: 319a441d1361 ("IB/core: Add receive flow steering support")
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 1 -
 drivers/infiniband/core/verbs.c      | 4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3f515a..2690c92 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3745,7 +3745,6 @@ int ib_uverbs_ex_create_flow(struct ib_uverbs_file *file,
 		err = PTR_ERR(flow_id);
 		goto err_free;
 	}
-	flow_id->qp = qp;
 	flow_id->uobject = uobj;
 	uobj->object = flow_id;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8368764..b7f9f3d 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1734,8 +1734,10 @@ struct ib_flow *ib_create_flow(struct ib_qp *qp,
 		return ERR_PTR(-ENOSYS);
 
 	flow_id = qp->device->create_flow(qp, flow_attr, domain);
-	if (!IS_ERR(flow_id))
+	if (!IS_ERR(flow_id)) {
 		atomic_inc(&qp->usecnt);
+		flow_id->qp = qp;
+	}
 	return flow_id;
 }
 EXPORT_SYMBOL(ib_create_flow);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
