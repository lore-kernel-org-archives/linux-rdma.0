From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH/RFC] IB/uverbs: Use anon_inodes instead of private infinibandeventfs
Date: Wed, 24 Feb 2010 16:53:53 -0800
Message-ID: <adaiq9mxhi6.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The anon_inodes interface has been split to allow creating a bare
(non-installed) file pointer and also extended to allow specifying
O_RDONLY in the flags.  This makes it a suitable replacement for the
private "infinibandeventfs" pseudo-filesystem used by uverbs, and this
replacement saves a small chunk of boilerplate code.

Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
I've had this kicking around for a few weeks, and it looks OK to me and
passes very light testing.  Anyone see any issues with merging this for
2.6.34?

 drivers/infiniband/Kconfig            |    1 +
 drivers/infiniband/core/uverbs_main.c |   57 ++------------------------------
 2 files changed, 5 insertions(+), 53 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index dd0db67..975adce 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -20,6 +20,7 @@ config INFINIBAND_USER_MAD
 
 config INFINIBAND_USER_ACCESS
 	tristate "InfiniBand userspace access (verbs and CM)"
+	select ANON_INODES
 	---help---
 	  Userspace InfiniBand access support.  This enables the
 	  kernel side of userspace verbs and the userspace
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 5f284ff..d4d3243 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -44,6 +44,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/cdev.h>
+#include <linux/anon_inodes.h>
 
 #include <asm/uaccess.h>
 
@@ -111,8 +112,6 @@ static ssize_t (*uverbs_cmd_table[])(struct ib_uverbs_file *file,
 	[IB_USER_VERBS_CMD_DESTROY_SRQ]   	= ib_uverbs_destroy_srq,
 };
 
-static struct vfsmount *uverbs_event_mnt;
-
 static void ib_uverbs_add_one(struct ib_device *device);
 static void ib_uverbs_remove_one(struct ib_device *device);
 
@@ -492,7 +491,6 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 					int is_async, int *fd)
 {
 	struct ib_uverbs_event_file *ev_file;
-	struct path path;
 	struct file *filp;
 	int ret;
 
@@ -515,27 +513,16 @@ struct file *ib_uverbs_alloc_event_file(struct ib_uverbs_file *uverbs_file,
 		goto err;
 	}
 
-	/*
-	 * fops_get() can't fail here, because we're coming from a
-	 * system call on a uverbs file, which will already have a
-	 * module reference.
-	 */
-	path.mnt = uverbs_event_mnt;
-	path.dentry = uverbs_event_mnt->mnt_root;
-	path_get(&path);
-	filp = alloc_file(&path, FMODE_READ, fops_get(&uverbs_event_fops));
+	filp = anon_inode_getfile("[uverbs-event]", &uverbs_event_fops,
+				  ev_file, O_RDONLY);
 	if (!filp) {
 		ret = -ENFILE;
 		goto err_fd;
 	}
 
-	filp->private_data = ev_file;
-
 	return filp;
 
 err_fd:
-	fops_put(&uverbs_event_fops);
-	path_put(&path);
 	put_unused_fd(*fd);
 
 err:
@@ -825,21 +812,6 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 	kfree(uverbs_dev);
 }
 
-static int uverbs_event_get_sb(struct file_system_type *fs_type, int flags,
-			       const char *dev_name, void *data,
-			       struct vfsmount *mnt)
-{
-	return get_sb_pseudo(fs_type, "infinibandevent:", NULL,
-			     INFINIBANDEVENTFS_MAGIC, mnt);
-}
-
-static struct file_system_type uverbs_event_fs = {
-	/* No owner field so module can be unloaded */
-	.name    = "infinibandeventfs",
-	.get_sb  = uverbs_event_get_sb,
-	.kill_sb = kill_litter_super
-};
-
 static int __init ib_uverbs_init(void)
 {
 	int ret;
@@ -864,33 +836,14 @@ static int __init ib_uverbs_init(void)
 		goto out_class;
 	}
 
-	ret = register_filesystem(&uverbs_event_fs);
-	if (ret) {
-		printk(KERN_ERR "user_verbs: couldn't register infinibandeventfs\n");
-		goto out_class;
-	}
-
-	uverbs_event_mnt = kern_mount(&uverbs_event_fs);
-	if (IS_ERR(uverbs_event_mnt)) {
-		ret = PTR_ERR(uverbs_event_mnt);
-		printk(KERN_ERR "user_verbs: couldn't mount infinibandeventfs\n");
-		goto out_fs;
-	}
-
 	ret = ib_register_client(&uverbs_client);
 	if (ret) {
 		printk(KERN_ERR "user_verbs: couldn't register client\n");
-		goto out_mnt;
+		goto out_class;
 	}
 
 	return 0;
 
-out_mnt:
-	mntput(uverbs_event_mnt);
-
-out_fs:
-	unregister_filesystem(&uverbs_event_fs);
-
 out_class:
 	class_destroy(uverbs_class);
 
@@ -904,8 +857,6 @@ out:
 static void __exit ib_uverbs_cleanup(void)
 {
 	ib_unregister_client(&uverbs_client);
-	mntput(uverbs_event_mnt);
-	unregister_filesystem(&uverbs_event_fs);
 	class_destroy(uverbs_class);
 	unregister_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES);
 	idr_destroy(&ib_uverbs_pd_idr);
-- 
1.7.0


-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
