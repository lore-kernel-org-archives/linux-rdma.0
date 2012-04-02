From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 6/6] [ofa_kernel] Add
 qib_0000_dcache_lock-and-mount-changes.patch
Date: Mon, 2 Apr 2012 00:06:17 -0500
Message-ID: <20120402050614.GA20016@shrek.cartoons>
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
 .../qib_0000_dcache_lock-and-mount-changes.patch   |   57 ++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 kernel_patches/backport/3.0_sles11sp2/qib_0000_dcache_lock-and-mount-changes.patch

diff --git a/kernel_patches/backport/3.0_sles11sp2/qib_0000_dcache_lock-and-mount-changes.patch b/kernel_patches/backport/3.0_sles11sp2/qib_0000_dcache_lock-and-mount-changes.patch
new file mode 100644
index 0000000..17bbdf2
--- /dev/null
+++ b/kernel_patches/backport/3.0_sles11sp2/qib_0000_dcache_lock-and-mount-changes.patch
@@ -0,0 +1,57 @@
+From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
+Subject: qib: dcache_lock and mount changes
+
+Index: ofa_kernel-1.5.4.1/drivers/infiniband/hw/qib/qib_fs.c
+===================================================================
+--- ofa_kernel-1.5.4.1.orig/drivers/infiniband/hw/qib/qib_fs.c
++++ ofa_kernel-1.5.4.1/drivers/infiniband/hw/qib/qib_fs.c
+@@ -386,17 +386,14 @@ static int remove_file(struct dentry *pa
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
+ 	} else {
+ 		spin_unlock(&tmp->d_lock);
+-		spin_unlock(&dcache_lock);
+ 	}
+ 
+ 	ret = 0;
+@@ -486,14 +483,14 @@ bail:
+ 	return ret;
+ }
+ 
+-static int qibfs_get_sb(struct file_system_type *fs_type, int flags,
+-			const char *dev_name, void *data, struct vfsmount *mnt)
++static struct dentry *qibfs_mount(struct file_system_type *fs_type, int flags,
++                        const char *dev_name, void *data)
+ {
+-	int ret = get_sb_single(fs_type, flags, data,
+-				qibfs_fill_super, mnt);
+-	if (ret >= 0)
+-		qib_super = mnt->mnt_sb;
+-	return ret;
++        struct dentry *ret;
++        ret = mount_single(fs_type, flags, data, qibfs_fill_super);
++        if (!IS_ERR(ret))
++                qib_super = ret->d_sb;
++        return ret;
+ }
+ 
+ static void qibfs_kill_super(struct super_block *s)
+@@ -534,7 +531,7 @@ int qibfs_remove(struct qib_devdata *dd)
+ static struct file_system_type qibfs_fs_type = {
+ 	.owner =        THIS_MODULE,
+ 	.name =         "ipathfs",
+-	.get_sb =       qibfs_get_sb,
++	.mount =        qibfs_mount,
+ 	.kill_sb =      qibfs_kill_super,
+ };
+ 
-- 
1.7.7


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
