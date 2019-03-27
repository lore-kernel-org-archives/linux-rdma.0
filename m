From: David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 31/68] vfs: Convert qib_fs/ipathfs to use the new mount
 API
Date: Wed, 27 Mar 2019 23:44:27 +0000
Message-ID: <155373026764.7602.420612273283807556.stgit@warthog.procyon.org.uk>
References: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155372999953.7602.13784796495137723805.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com
List-Id: linux-rdma@vger.kernel.org

Convert the qib_fs/ipathfs filesystem to the new internal mount API as the old
one will be obsoleted and removed.  This allows greater flexibility in
communication of mount parameters between userspace, the VFS and the
filesystem.

See Documentation/filesystems/mount_api.txt for more information.

[Q] Can qib_remove() race with qibfs_kill_super()?  Should qib_super
    accesses be serialised with some sort of lock?

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
cc: linux-rdma@vger.kernel.org
---

 drivers/infiniband/hw/qib/qib_fs.c |   26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 1d940a2885c9..fc4f62a248a1 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -34,6 +34,7 @@
 
 #include <linux/module.h>
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
@@ -506,7 +507,7 @@ static int remove_device_files(struct super_block *sb,
  * after device init.  The direct add_cntr_files() call handles adding
  * them from the init code, when the fs is already mounted.
  */
-static int qibfs_fill_super(struct super_block *sb, void *data, int silent)
+static int qibfs_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct qib_devdata *dd, *tmp;
 	unsigned long flags;
@@ -540,17 +541,26 @@ static int qibfs_fill_super(struct super_block *sb, void *data, int silent)
 	return ret;
 }
 
-static struct dentry *qibfs_mount(struct file_system_type *fs_type, int flags,
-			const char *dev_name, void *data)
+static int qibfs_get_tree(struct fs_context *fc)
 {
-	struct dentry *ret;
+	int ret;
 
-	ret = mount_single(fs_type, flags, data, qibfs_fill_super);
-	if (!IS_ERR(ret))
-		qib_super = ret->d_sb;
+	ret = vfs_get_super(fc, vfs_get_single_super, qibfs_fill_super);
+	if (ret == 0)
+		qib_super = fc->root->d_sb;
 	return ret;
 }
 
+static const struct fs_context_operations qibfs_context_ops = {
+	.get_tree	= qibfs_get_tree,
+};
+
+static int qibfs_init_fs_context(struct fs_context *fc)
+{
+	fc->ops = &qibfs_context_ops;
+	return 0;
+}
+
 static void qibfs_kill_super(struct super_block *s)
 {
 	kill_litter_super(s);
@@ -589,7 +599,7 @@ int qibfs_remove(struct qib_devdata *dd)
 static struct file_system_type qibfs_fs_type = {
 	.owner =        THIS_MODULE,
 	.name =         "ipathfs",
-	.mount =        qibfs_mount,
+	.init_fs_context = qibfs_init_fs_context,
 	.kill_sb =      qibfs_kill_super,
 };
 MODULE_ALIAS_FS("ipathfs");
