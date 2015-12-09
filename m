From: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/usnic: Improve a failure message
Date: Wed,  9 Dec 2015 10:42:14 -0800
Message-ID: <1449686539-29959-1-git-send-email-neescoba@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_debugfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index 5e55b8b..92dc66c 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -157,8 +157,9 @@ void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_flow *qp_flow)
 							qp_flow,
 							&flowinfo_ops);
 	if (IS_ERR_OR_NULL(qp_flow->dbgfs_dentry)) {
-		usnic_err("Failed to create dbg fs entry for flow %u\n",
-				qp_flow->flow->flow_id);
+		usnic_err("Failed to create dbg fs entry for flow %u with error %ld\n",
+				qp_flow->flow->flow_id,
+				PTR_ERR(qp_flow->dbgfs_dentry));
 	}
 }
 
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
