From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] IB/usnic: Remove unused variable in usnic_debugfs_exit()
Date: Wed, 15 Jan 2014 13:52:55 +0800
Message-ID: <CAPgLHd80yT3=L3XgHrurwReqC=OWT2NFNVcSVwLtn5aMwUcRHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

The variable qp_grp is initialized but never used
otherwise, so remove the unused variable.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_debugfs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index 6cb2e7c..5d13860 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -131,13 +131,9 @@ void usnic_debugfs_exit(void)
 
 void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_flow *qp_flow)
 {
-	struct usnic_ib_qp_grp *qp_grp;
-
 	if (IS_ERR_OR_NULL(flows_dentry))
 		return;
 
-	qp_grp = qp_flow->qp_grp;
-
 	scnprintf(qp_flow->dentry_name, sizeof(qp_flow->dentry_name),
 			"%u", qp_flow->flow->flow_id);
 	qp_flow->dbgfs_dentry = debugfs_create_file(qp_flow->dentry_name,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
