From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 4/6] [ofa_kernel] Add
  ipath_0000_-sched_and_mount_changes.patch
Date: Mon, 2 Apr 2012 00:05:44 -0500
Message-ID: <20120402050541.GA20007@shrek.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
---
 .../ipath_0000_-sched_and_mount_changes.patch      |  129 ++++++++++++++++++++
 1 files changed, 129 insertions(+), 0 deletions(-)
 create mode 100644 kernel_patches/backport/3.0_sles11sp2/ipath_0000_-sched_and_mount_changes.patch

diff --git a/kernel_patches/backport/3.0_sles11sp2/ipath_0000_-sched_and_mount_changes.patch b/kernel_patches/backport/3.0_sles11sp2/ipath_0000_-sched_and_mount_changes.patch
new file mode 100644
index 0000000..4f548d2
--- /dev/null
+++ b/kernel_patches/backport/3.0_sles11sp2/ipath_0000_-sched_and_mount_changes.patch
@@ -0,0 +1,129 @@
+From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
+Subject: [PATCH] ipath - add sched.h and change get_sb to mount
+
+Add linux/sched.h where required.
+commit fc14f2fef682df677d64a145256dbd263df2aa7b convert get_sb_single() users
+commit b5c84bf6f6fa3a7dfdcb556023a62953574b60ee fs: dcache remove dcache_lock
+
+Index: ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_file_ops.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/drivers/infiniband/hw/ipath/ipath_file_ops.c
++++ ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_file_ops.c
+@@ -40,7 +40,6 @@
+ #include <linux/highmem.h>
+ #include <linux/io.h>
+ #include <linux/jiffies.h>
+-#include <linux/smp_lock.h>
+ #include <asm/pgtable.h>
+ 
+ #include "ipath_kernel.h"
+@@ -1822,7 +1821,6 @@ done:
+ static int ipath_open(struct inode *in, struct file *fp)
+ {
+ 	/* The real work is performed later in ipath_assign_port() */
+-	cycle_kernel_lock();
+ 	fp->private_data = kzalloc(sizeof(struct ipath_filedata), GFP_KERNEL);
+ 	return fp->private_data ? 0 : -ENOMEM;
+ }
+Index: ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_fs.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/drivers/infiniband/hw/ipath/ipath_fs.c
++++ ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_fs.c
+@@ -273,18 +273,14 @@ static int remove_file(struct dentry *pa
+ 		goto bail;
+ 	}
+ 
+-	spin_lock(&dcache_lock);
+ 	spin_lock(&tmp->d_lock);
+ 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
+-		dget_locked(tmp);
++		dget_dlock(tmp);
+ 		__d_drop(tmp);
+ 		spin_unlock(&tmp->d_lock);
+-		spin_unlock(&dcache_lock);
+ 		simple_unlink(parent->d_inode, tmp);
+-	} else {
++	} else
+ 		spin_unlock(&tmp->d_lock);
+-		spin_unlock(&dcache_lock);
+-	}
+ 
+ 	ret = 0;
+ bail:
+@@ -360,13 +356,13 @@ bail:
+ 	return ret;
+ }
+ 
+-static int ipathfs_get_sb(struct file_system_type *fs_type, int flags,
+-			const char *dev_name, void *data, struct vfsmount *mnt)
++static struct dentry *ipathfs_mount(struct file_system_type *fs_type,
++			int flags, const char *dev_name, void *data)
+ {
+-	int ret = get_sb_single(fs_type, flags, data,
+-				    ipathfs_fill_super, mnt);
+-	if (ret >= 0)
+-		ipath_super = mnt->mnt_sb;
++	struct dentry *ret;
++	ret = mount_single(fs_type, flags, data, ipathfs_fill_super);
++	if (!IS_ERR(ret))
++		ipath_super = ret->d_sb;
+ 	return ret;
+ }
+ 
+@@ -409,7 +405,7 @@ bail:
+ static struct file_system_type ipathfs_fs_type = {
+ 	.owner =	THIS_MODULE,
+ 	.name =		"ipathfs",
+-	.get_sb =	ipathfs_get_sb,
++	.mount =	ipathfs_mount,
+ 	.kill_sb =	ipathfs_kill_super,
+ };
+ 
+Index: ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_intr.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/drivers/infiniband/hw/ipath/ipath_intr.c
++++ ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_intr.c
+@@ -33,6 +33,7 @@
+ 
+ #include <linux/pci.h>
+ #include <linux/delay.h>
++#include <linux/sched.h>
+ 
+ #include "ipath_kernel.h"
+ #include "ipath_verbs.h"
+Index: ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_ruc.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/drivers/infiniband/hw/ipath/ipath_ruc.c
++++ ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_ruc.c
+@@ -31,6 +31,7 @@
+  * SOFTWARE.
+  */
+ 
++#include <linux/sched.h>
+ #include <linux/spinlock.h>
+ 
+ #include "ipath_verbs.h"
+Index: ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_ud.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/drivers/infiniband/hw/ipath/ipath_ud.c
++++ ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_ud.c
+@@ -31,6 +31,7 @@
+  * SOFTWARE.
+  */
+ 
++#include <linux/sched.h>
+ #include <rdma/ib_smi.h>
+ 
+ #include "ipath_verbs.h"
+Index: ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/drivers/infiniband/hw/ipath/ipath_user_sdma.c
++++ ofa_kernel-1.5.4.1/drivers/infiniband/hw/ipath/ipath_user_sdma.c
+@@ -33,6 +33,7 @@
+ #include <linux/types.h>
+ #include <linux/device.h>
+ #include <linux/dmapool.h>
++#include <linux/sched.h>
+ #include <linux/slab.h>
+ #include <linux/list.h>
+ #include <linux/highmem.h>
-- 
1.7.7


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
