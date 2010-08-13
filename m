From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [RFC PATCH] RDMA/UCMA: Allow tuning the max backlog.
Date: Fri, 13 Aug 2010 15:56:34 -0500
Message-ID: <20100813205634.3763.55419.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For iWARP connections, the connect request is TCP payload an on already
established TCP connection.  So the connection request is transmitted
and acked at the TCP level by the time the connect request gets dropped
in the ucma.  The end result is the connection gets rejected by the
iWARP provider.  Further, a 32 node 256NP OpenMPI job will generate >
128 connect requests on some ranks.

This patch increases the default max backlog to 1024, and adds a sysctl
variable so the backlog can be adjusted at run time.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/ucma.c |   39 +++++++++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index ac7edc2..12d8c0f 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -40,6 +40,7 @@
 #include <linux/in6.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
+#include <linux/sysctl.h>
 
 #include <rdma/rdma_user_cm.h>
 #include <rdma/ib_marshall.h>
@@ -50,8 +51,24 @@ MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("RDMA Userspace Connection Manager Access");
 MODULE_LICENSE("Dual BSD/GPL");
 
-enum {
-	UCMA_MAX_BACKLOG	= 128
+static unsigned int max_backlog = 1024;
+
+static struct ctl_table_header *ucma_ctl_table_hdr;
+static ctl_table ucma_ctl_table[] = {
+	{
+		.procname 	= "max_backlog",
+		.data 		= &max_backlog,
+		.maxlen 	= sizeof max_backlog,
+		.mode 		= 0644,
+		.proc_handler 	= proc_dointvec,
+	},
+	{ }
+};
+
+struct ctl_path ucma_ctl_path[] = {
+	{ .procname = "net" },
+	{ .procname = "rdma_ucm" },
+	{ }
 };
 
 struct ucma_file {
@@ -686,8 +703,8 @@ static ssize_t ucma_listen(struct ucma_file *file, const char __user *inbuf,
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	ctx->backlog = cmd.backlog > 0 && cmd.backlog < UCMA_MAX_BACKLOG ?
-		       cmd.backlog : UCMA_MAX_BACKLOG;
+	ctx->backlog = cmd.backlog > 0 && cmd.backlog < max_backlog ?
+		       cmd.backlog : max_backlog;
 	ret = rdma_listen(ctx->cm_id, ctx->backlog);
 	ucma_put_ctx(ctx);
 	return ret;
@@ -1279,16 +1296,26 @@ static int __init ucma_init(void)
 	ret = device_create_file(ucma_misc.this_device, &dev_attr_abi_version);
 	if (ret) {
 		printk(KERN_ERR "rdma_ucm: couldn't create abi_version attr\n");
-		goto err;
+		goto err1;
+	}
+	
+	ucma_ctl_table_hdr = register_sysctl_paths(ucma_ctl_path, ucma_ctl_table);
+	if (!ucma_ctl_table_hdr) {
+		printk(KERN_ERR "rdma_ucm: couldn't register sysctl paths\n");
+		ret = -ENOMEM;
+		goto err2;
 	}
 	return 0;
-err:
+err2:
+	device_remove_file(ucma_misc.this_device, &dev_attr_abi_version);
+err1:
 	misc_deregister(&ucma_misc);
 	return ret;
 }
 
 static void __exit ucma_cleanup(void)
 {
+	unregister_sysctl_table(ucma_ctl_table_hdr);
 	device_remove_file(ucma_misc.this_device, &dev_attr_abi_version);
 	misc_deregister(&ucma_misc);
 	idr_destroy(&ctx_idr);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
