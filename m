From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v3 7/8] debugfs: call debugfs_real_fops() only after debugfs_file_get()
Date: Tue, 31 Oct 2017 00:15:53 +0100
Message-ID: <20171030231554.6200-8-nicstange@gmail.com>
References: <CAOjnSCazvybpH5ZhHn=iTLm_dVGEdr=W1pUQv6zowRisB1MWTQ@mail.gmail.com>
 <20171030231554.6200-1-nicstange@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171030231554.6200-1-nicstange@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>, Tyler Hall <tylerwhall@gmail.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Nicolai Stange <nicstange@gmail.com>
List-Id: linux-rdma@vger.kernel.org

The current implementation of debugfs_real_fops() relies on a
debugfs_fsdata instance to be installed at ->d_fsdata.

With future patches introducing lazy allocation of these, this requirement
will be guaranteed to be fullfilled only inbetween a
debugfs_file_get()/debugfs_file_put() pair.

The full proxies' fops implemented by debugfs happen to be the only
offenders. Fix them up by moving their debugfs_real_fops() calls past those
to debugfs_file_get().

full_proxy_release() is special as it doesn't invoke debugfs_file_get() at
all. Leave it alone for now.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 fs/debugfs/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 53f5c9a2af88..bc3549c95574 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -144,13 +144,13 @@ const struct file_operations debugfs_open_proxy_file_operations = {
 static ret_type full_proxy_ ## name(proto)				\
 {									\
 	struct dentry *dentry = F_DENTRY(filp);			\
-	const struct file_operations *real_fops =			\
-		debugfs_real_fops(filp);				\
+	const struct file_operations *real_fops;			\
 	ret_type r;							\
 									\
 	r = debugfs_file_get(dentry);					\
 	if (unlikely(r))						\
 		return r;						\
+	real_fops = debugfs_real_fops(filp);				\
 	r = real_fops->name(args);					\
 	debugfs_file_put(dentry);					\
 	return r;							\
@@ -177,13 +177,14 @@ FULL_PROXY_FUNC(unlocked_ioctl, long, filp,
 static unsigned int full_proxy_poll(struct file *filp,
 				struct poll_table_struct *wait)
 {
-	const struct file_operations *real_fops = debugfs_real_fops(filp);
 	struct dentry *dentry = F_DENTRY(filp);
 	unsigned int r = 0;
+	const struct file_operations *real_fops;
 
 	if (debugfs_file_get(dentry))
 		return POLLHUP;
 
+	real_fops = debugfs_real_fops(filp);
 	r = real_fops->poll(filp, wait);
 	debugfs_file_put(dentry);
 	return r;
-- 
2.13.6
