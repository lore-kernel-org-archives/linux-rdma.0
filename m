From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cm: use a default listen backlog if needed
Date: Fri, 25 Jul 2014 09:11:33 -0500
Message-ID: <20140725141133.19996.57359.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the user creates a listening cm_id with backlog of 0 the IWCM ends up
not allowing any connection requests at all.  The correct behavior is for
the IWCM to pick a default value if the user backlog parameter is zero.

Lustre from version 1.8.8 onward uses a backlog of 0 which breaks iwarp
support.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 drivers/infiniband/core/iwcm.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 3d2e489..ff9163d 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -46,6 +46,7 @@
 #include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
 
 #include <rdma/iw_cm.h>
 #include <rdma/ib_addr.h>
@@ -65,6 +66,20 @@ struct iwcm_work {
 	struct list_head free_list;
 };
 
+static unsigned int default_backlog = 256;
+
+static struct ctl_table_header *iwcm_ctl_table_hdr;
+static struct ctl_table iwcm_ctl_table[] = {
+	{
+		.procname	= "default_backlog",
+		.data		= &default_backlog,
+		.maxlen		= sizeof(default_backlog),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{ }
+};
+
 /*
  * The following services provide a mechanism for pre-allocating iwcm_work
  * elements.  The design pre-allocates them  based on the cm_id type:
@@ -425,6 +440,9 @@ int iw_cm_listen(struct iw_cm_id *cm_id, int backlog)
 
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
 
+	if (!backlog)
+		backlog = default_backlog;
+
 	ret = alloc_work_entries(cm_id_priv, backlog);
 	if (ret)
 		return ret;
@@ -1030,11 +1048,20 @@ static int __init iw_cm_init(void)
 	if (!iwcm_wq)
 		return -ENOMEM;
 
+	iwcm_ctl_table_hdr = register_net_sysctl(&init_net, "net/iw_cm",
+						 iwcm_ctl_table);
+	if (!iwcm_ctl_table_hdr) {
+		pr_err("iw_cm: couldn't register sysctl paths\n");
+		destroy_workqueue(iwcm_wq);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
 static void __exit iw_cm_cleanup(void)
 {
+	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
