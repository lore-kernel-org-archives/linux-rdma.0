From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 5/6] IB/cm: Destroy idr as part of the module init error flow
Date: Wed, 11 Jul 2012 18:33:44 +0300
Message-ID: <1342020825-18878-6-git-send-email-ogerlitz@mellanox.com>
References: <1342020825-18878-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342020825-18878-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Clean the idr as part of the error flow since it is a resource too.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cm.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c889aae..d67999f 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3848,24 +3848,28 @@ static int __init ib_cm_init(void)
 	INIT_LIST_HEAD(&cm.timewait_list);
 
 	ret = class_register(&cm_class);
-	if (ret)
-		return -ENOMEM;
+	if (ret) {
+		ret = -ENOMEM;
+		goto error1;
+	}
 
 	cm.wq = create_workqueue("ib_cm");
 	if (!cm.wq) {
 		ret = -ENOMEM;
-		goto error1;
+		goto error2;
 	}
 
 	ret = ib_register_client(&cm_client);
 	if (ret)
-		goto error2;
+		goto error3;
 
 	return 0;
-error2:
+error3:
 	destroy_workqueue(cm.wq);
-error1:
+error2:
 	class_unregister(&cm_class);
+error1:
+	idr_destroy(&cm.local_id_table);
 	return ret;
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
