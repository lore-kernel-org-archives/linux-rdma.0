From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/5] ib/umad: update module to pr_* style print messages
Date: Mon,  5 May 2014 21:44:46 -0400
Message-ID: <1399340690-27677-2-git-send-email-ira.weiny@intel.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399340690-27677-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Also combine previously line broken user-visible strings as per
Documentation/CodingStyle

"However, never break user-visible strings such as printk messages, because
that breaks the ability to grep for them."

Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index f0d588f..0df292a 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -33,6 +33,8 @@
  * SOFTWARE.
  */
 
+#define pr_fmt(fmt) "user_mad: " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -669,10 +671,9 @@ found:
 	if (!file->already_used) {
 		file->already_used = 1;
 		if (!file->use_pkey_index) {
-			printk(KERN_WARNING "user_mad: process %s did not enable "
-			       "P_Key index support.\n", current->comm);
-			printk(KERN_WARNING "user_mad:   Documentation/infiniband/user_mad.txt "
-			       "has info on the new ABI.\n");
+			pr_warn("process %s did not enable P_Key index support.\n",
+				current->comm);
+			pr_warn("   Documentation/infiniband/user_mad.txt has info on the new ABI.\n");
 		}
 	}
 
@@ -982,7 +983,7 @@ static int find_overflow_devnum(void)
 		ret = alloc_chrdev_region(&overflow_maj, 0, IB_UMAD_MAX_PORTS * 2,
 					  "infiniband_mad");
 		if (ret) {
-			printk(KERN_ERR "user_mad: couldn't register dynamic device number\n");
+			pr_err("couldn't register dynamic device number\n");
 			return ret;
 		}
 	}
@@ -1187,14 +1188,14 @@ static int __init ib_umad_init(void)
 	ret = register_chrdev_region(base_dev, IB_UMAD_MAX_PORTS * 2,
 				     "infiniband_mad");
 	if (ret) {
-		printk(KERN_ERR "user_mad: couldn't register device number\n");
+		pr_err("couldn't register device number\n");
 		goto out;
 	}
 
 	umad_class = class_create(THIS_MODULE, "infiniband_mad");
 	if (IS_ERR(umad_class)) {
 		ret = PTR_ERR(umad_class);
-		printk(KERN_ERR "user_mad: couldn't create class infiniband_mad\n");
+		pr_err("couldn't create class infiniband_mad\n");
 		goto out_chrdev;
 	}
 
@@ -1202,13 +1203,13 @@ static int __init ib_umad_init(void)
 
 	ret = class_create_file(umad_class, &class_attr_abi_version.attr);
 	if (ret) {
-		printk(KERN_ERR "user_mad: couldn't create abi_version attribute\n");
+		pr_err("couldn't create abi_version attribute\n");
 		goto out_class;
 	}
 
 	ret = ib_register_client(&umad_client);
 	if (ret) {
-		printk(KERN_ERR "user_mad: couldn't register ib_umad client\n");
+		pr_err("couldn't register ib_umad client\n");
 		goto out_class;
 	}
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
