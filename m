From: Heloise NH <os@iscas.ac.cn>
Subject: [PATCH] fix return value error
Date: Wed, 14 Oct 2015 16:17:59 +0800
Message-ID: <1444810679-30592-1-git-send-email-os@iscas.ac.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: infinipath@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, os@iscas.ac.cn, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Heloise NH <os@iscas.ac.cn>
---
 drivers/infiniband/hw/ipath/ipath_fs.c | 2 +-
 drivers/infiniband/hw/qib/qib_fs.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 25422a3..da753bc 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -53,7 +53,7 @@ static int ipathfs_mknod(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = new_inode(dir->i_sb);
 
 	if (!inode) {
-		error = -EPERM;
+		error = -ENOMEM;
 		goto bail;
 	}
 
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index 13ef22b..a4c5a6a 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -55,7 +55,7 @@ static int qibfs_mknod(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = new_inode(dir->i_sb);
 
 	if (!inode) {
-		error = -EPERM;
+		error = -ENOMEM;
 		goto bail;
 	}
 
-- 
1.9.1
