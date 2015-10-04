From: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] IB/iser: fix a comment typo
Date: Sun,  4 Oct 2015 17:00:05 +0800
Message-ID: <79a2c1916a6cfbfecda2048cc14f428cc7a0fe68.1443949081.git.geliangtang@163.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Just fix a typo in the code comment.

Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index f58ff96..8f2f105 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -111,7 +111,7 @@ module_param_named(pi_guard, iser_pi_guard, int, S_IRUGO);
 MODULE_PARM_DESC(pi_guard, "T10-PI guard_type [deprecated]");
 
 /*
- * iscsi_iser_recv() - Process a successfull recv completion
+ * iscsi_iser_recv() - Process a successful recv completion
  * @conn:         iscsi connection
  * @hdr:          iscsi header
  * @rx_data:      buffer containing receive data payload
-- 
2.5.0


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
