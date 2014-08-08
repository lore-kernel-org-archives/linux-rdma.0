From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH for-3.17 1/5] ib/umad: update module to [pr|dev]_* style print messages
Date: Fri,  8 Aug 2014 19:00:52 -0400
Message-ID: <1407538856-13968-2-git-send-email-ira.weiny@intel.com>
References: <1407538856-13968-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407538856-13968-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Use dev_* style print when struct device is available.

Also combine previously line broken user-visible strings as per
Documentation/CodingStyle

"However, never break user-visible strings such as printk messages, because
that breaks the ability to grep for them."

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/user_mad.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 1acb991..6be596d 100644
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
@@ -673,10 +675,11 @@ found:
 	if (!file->already_used) {
 		file->already_used = 1;
 		if (!file->use_pkey_index) {
-			printk(KERN_WARNING "user_mad: process %s did not enable "
-			       "P_Key index support.\n", current->comm);
-			printk(KERN_WARNING "user_mad:   Documentation/infiniband/user_mad.txt "
-			       "has info on the new ABI.\n");
+			dev_warn(file->port->dev,
+				"process %s did not enable P_Key index support.\n",
+				current->comm);
+			dev_warn(file->port->dev,
+				"   Documentation/infiniband/user_mad.txt has info on the new ABI.\n");
 		}
 	}
 
@@ -983,7 +986,7 @@ static CLASS_ATTR_STRING(abi_version, S_IRUGO,
 
 static dev_t overflow_maj;
 static DECLARE_BITMAP(overflow_map, IB_UMAD_MAX_PORTS);
-static int find_overflow_devnum(void)
+static int find_overflow_devnum(struct ib_device *device)
 {
 	int ret;
 
@@ -991,7 +994,8 @@ static int find_overflow_devnum(void)
 		ret = alloc_chrdev_region(&overflow_maj, 0, IB_UMAD_MAX_PORTS * 2,
 					  "infiniband_mad");
 		if (ret) {
-			printk(KERN_ERR "user_mad: couldn't register dynamic device number\n");
+			dev_err(&device->dev,
+				"couldn't register dynamic device number\n");
 			return ret;
 		}
 	}
@@ -1014,7 +1018,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	devnum = find_first_zero_bit(dev_map, IB_UMAD_MAX_PORTS);
 	if (devnum >= IB_UMAD_MAX_PORTS) {
 		spin_unlock(&port_lock);
-		devnum = find_overflow_devnum();
+		devnum = find_overflow_devnum(device);
 		if (devnum < 0)
 			return -1;
 
@@ -1200,14 +1204,14 @@ static int __init ib_umad_init(void)
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
 
@@ -1215,13 +1219,13 @@ static int __init ib_umad_init(void)
 
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
