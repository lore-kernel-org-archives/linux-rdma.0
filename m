From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] RDMA/cm: check that idr_pre_get didn't fail and clean it in error flow
Date: Thu, 3 Nov 2011 15:19:47 +0200
Message-ID: <201111031519.48018.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function idr_pre_get may fail, so there is a need to check the status of
it. Since this function allocate resources, we need to clean them during the
resource cleaning in case of error.

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Reviewed-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---

 drivers/infiniband/core/cm.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4104ea2..31df1b4 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3843,28 +3843,34 @@ static int __init ib_cm_init(void)
 	cm.remote_sidr_table = RB_ROOT;
 	idr_init(&cm.local_id_table);
 	get_random_bytes(&cm.random_id_operand, sizeof cm.random_id_operand);
-	idr_pre_get(&cm.local_id_table, GFP_KERNEL);
+	if (!idr_pre_get(&cm.local_id_table, GFP_KERNEL))
+		return -ENOMEM;
+
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
