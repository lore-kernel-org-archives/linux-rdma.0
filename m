From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 6/8] debugfs: purge obsolete SRCU based removal protection
Date: Tue, 31 Oct 2017 00:15:52 +0100
Message-ID: <20171030231554.6200-7-nicstange@gmail.com>
References: <CAOjnSCazvybpH5ZhHn=iTLm_dVGEdr=W1pUQv6zowRisB1MWTQ@mail.gmail.com>
 <20171030231554.6200-1-nicstange@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171030231554.6200-1-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>, Tyler Hall <tylerwhall@gmail.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Purge the SRCU based file removal race protection in favour of the new,
refcount based debugfs_file_get()/debugfs_file_put() API.

Fixes: 49d200deaa68 ("debugfs: prevent access to removed files' private
                      data")
Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 fs/debugfs/file.c       | 48 ------------------------------------------------
 fs/debugfs/inode.c      |  7 -------
 include/linux/debugfs.h | 19 -------------------
 lib/Kconfig.debug       |  1 -
 4 files changed, 75 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index d3a972b45ff0..53f5c9a2af88 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/atomic.h>
 #include <linux/device.h>
-#include <linux/srcu.h>
 #include <asm/poll.h>
 
 #include "internal.h"
@@ -48,53 +47,6 @@ const struct file_operations debugfs_noop_file_operations = {
 	.llseek =	noop_llseek,
 };
 
-/**
- * debugfs_use_file_start - mark the beginning of file data access
- * @dentry: the dentry object whose data is being accessed.
- * @srcu_idx: a pointer to some memory to store a SRCU index in.
- *
- * Up to a matching call to debugfs_use_file_finish(), any
- * successive call into the file removing functions debugfs_remove()
- * and debugfs_remove_recursive() will block. Since associated private
- * file data may only get freed after a successful return of any of
- * the removal functions, you may safely access it after a successful
- * call to debugfs_use_file_start() without worrying about
- * lifetime issues.
- *
- * If -%EIO is returned, the file has already been removed and thus,
- * it is not safe to access any of its data. If, on the other hand,
- * it is allowed to access the file data, zero is returned.
- *
- * Regardless of the return code, any call to
- * debugfs_use_file_start() must be followed by a matching call
- * to debugfs_use_file_finish().
- */
-int debugfs_use_file_start(const struct dentry *dentry, int *srcu_idx)
-	__acquires(&debugfs_srcu)
-{
-	*srcu_idx = srcu_read_lock(&debugfs_srcu);
-	barrier();
-	if (d_unlinked(dentry))
-		return -EIO;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(debugfs_use_file_start);
-
-/**
- * debugfs_use_file_finish - mark the end of file data access
- * @srcu_idx: the SRCU index "created" by a former call to
- *            debugfs_use_file_start().
- *
- * Allow any ongoing concurrent call into debugfs_remove() or
- * debugfs_remove_recursive() blocked by a former call to
- * debugfs_use_file_start() to proceed and return to its caller.
- */
-void debugfs_use_file_finish(int srcu_idx) __releases(&debugfs_srcu)
-{
-	srcu_read_unlock(&debugfs_srcu, srcu_idx);
-}
-EXPORT_SYMBOL_GPL(debugfs_use_file_finish);
-
 #define F_DENTRY(filp) ((filp)->f_path.dentry)
 
 const struct file_operations *debugfs_real_fops(const struct file *filp)
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 6449eb935540..f587aded46b5 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -27,14 +27,11 @@
 #include <linux/parser.h>
 #include <linux/magic.h>
 #include <linux/slab.h>
-#include <linux/srcu.h>
 
 #include "internal.h"
 
 #define DEBUGFS_DEFAULT_MODE	0700
 
-DEFINE_SRCU(debugfs_srcu);
-
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 static bool debugfs_registered;
@@ -693,8 +690,6 @@ void debugfs_remove(struct dentry *dentry)
 	inode_unlock(d_inode(parent));
 	if (!ret)
 		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
-
-	synchronize_srcu(&debugfs_srcu);
 }
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
@@ -768,8 +763,6 @@ void debugfs_remove_recursive(struct dentry *dentry)
 	if (!__debugfs_remove(child, parent))
 		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	inode_unlock(d_inode(parent));
-
-	synchronize_srcu(&debugfs_srcu);
 }
 EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index c5eda259b9d6..9f821a43bb0d 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -23,7 +23,6 @@
 
 struct device;
 struct file_operations;
-struct srcu_struct;
 
 struct debugfs_blob_wrapper {
 	void *data;
@@ -43,8 +42,6 @@ struct debugfs_regset32 {
 
 extern struct dentry *arch_debugfs_dir;
 
-extern struct srcu_struct debugfs_srcu;
-
 #define DEFINE_DEBUGFS_ATTRIBUTE(__fops, __get, __set, __fmt)		\
 static int __fops ## _open(struct inode *inode, struct file *file)	\
 {									\
@@ -90,11 +87,6 @@ struct dentry *debugfs_create_automount(const char *name,
 void debugfs_remove(struct dentry *dentry);
 void debugfs_remove_recursive(struct dentry *dentry);
 
-int debugfs_use_file_start(const struct dentry *dentry, int *srcu_idx)
-	__acquires(&debugfs_srcu);
-
-void debugfs_use_file_finish(int srcu_idx) __releases(&debugfs_srcu);
-
 const struct file_operations *debugfs_real_fops(const struct file *filp);
 
 int debugfs_file_get(struct dentry *dentry);
@@ -227,17 +219,6 @@ static inline void debugfs_remove(struct dentry *dentry)
 static inline void debugfs_remove_recursive(struct dentry *dentry)
 { }
 
-static inline int debugfs_use_file_start(const struct dentry *dentry,
-					int *srcu_idx)
-	__acquires(&debugfs_srcu)
-{
-	return 0;
-}
-
-static inline void debugfs_use_file_finish(int srcu_idx)
-	__releases(&debugfs_srcu)
-{ }
-
 static inline int debugfs_file_get(struct dentry *dentry)
 {
 	return 0;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 03e2ac7cceb6..f6140d5a50f1 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -326,7 +326,6 @@ config PAGE_OWNER
 
 config DEBUG_FS
 	bool "Debug Filesystem"
-	select SRCU
 	help
 	  debugfs is a virtual file system that kernel developers use to put
 	  debugging files into.  Enable this option to be able to read and
-- 
2.13.6
