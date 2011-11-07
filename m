From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V2] RDMA/cm: destroy idr as part of the cleanup in the error flow
Date: Mon, 7 Nov 2011 12:59:49 +0200
Message-ID: <201111071259.49462.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean the idr as part of the cleanup flow since it is a resource too.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
V2 - don't check if idr_pre_get() failed, , we'll just try again later.

 drivers/infiniband/core/cm.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4104ea2..1f04e82 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3847,24 +3847,28 @@ static int __init ib_cm_init(void)
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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
