From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 3/8] debugfs: debugfs_real_fops(): drop __must_hold sparse annotation
Date: Tue, 31 Oct 2017 00:15:49 +0100
Message-ID: <20171030231554.6200-4-nicstange@gmail.com>
References: <CAOjnSCazvybpH5ZhHn=iTLm_dVGEdr=W1pUQv6zowRisB1MWTQ@mail.gmail.com>
 <20171030231554.6200-1-nicstange@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171030231554.6200-1-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>, Tyler Hall <tylerwhall@gmail.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Currently, debugfs_real_fops() is annotated with a
__must_hold(&debugfs_srcu) sparse annotation.

With the conversion of the SRCU based protection of users against
concurrent file removals to a per-file refcount based scheme, this becomes
wrong.

Drop this annotation.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 fs/debugfs/file.c       | 6 +-----
 include/linux/debugfs.h | 3 +--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 6644bfdea2f8..08511678b782 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -98,13 +98,9 @@ EXPORT_SYMBOL_GPL(debugfs_use_file_finish);
 #define F_DENTRY(filp) ((filp)->f_path.dentry)
 
 const struct file_operations *debugfs_real_fops(const struct file *filp)
-	__must_hold(&debugfs_srcu)
 {
 	struct debugfs_fsdata *fsd = F_DENTRY(filp)->d_fsdata;
-	/*
-	 * Neither the pointer to the struct file_operations, nor its
-	 * contents ever change -- srcu_dereference() is not needed here.
-	 */
+
 	return fsd->real_fops;
 }
 EXPORT_SYMBOL_GPL(debugfs_real_fops);
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 3b914d588148..c5eda259b9d6 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -95,8 +95,7 @@ int debugfs_use_file_start(const struct dentry *dentry, int *srcu_idx)
 
 void debugfs_use_file_finish(int srcu_idx) __releases(&debugfs_srcu);
 
-const struct file_operations *debugfs_real_fops(const struct file *filp)
-	__must_hold(&debugfs_srcu);
+const struct file_operations *debugfs_real_fops(const struct file *filp);
 
 int debugfs_file_get(struct dentry *dentry);
 void debugfs_file_put(struct dentry *dentry);
-- 
2.13.6
