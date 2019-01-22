From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4/8] infiniband: qib: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:17:56 +0100
Message-ID: <20190122151800.15092-5-gregkh@linuxfoundation.org>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/qib/qib_debugfs.c | 26 +++++++------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_debugfs.c b/drivers/infiniband/hw/qib/qib_debugfs.c
index 5ed1ed93380f..8546e69c6a07 100644
--- a/drivers/infiniband/hw/qib/qib_debugfs.c
+++ b/drivers/infiniband/hw/qib/qib_debugfs.c
@@ -66,15 +66,6 @@ static const struct file_operations _##name##_file_ops = { \
 	.release = seq_release \
 };
 
-#define DEBUGFS_FILE_CREATE(name) \
-do { \
-	struct dentry *ent; \
-	ent = debugfs_create_file(#name , 0400, ibd->qib_ibdev_dbg, \
-		ibd, &_##name##_file_ops); \
-	if (!ent) \
-		pr_warn("create of " #name " failed\n"); \
-} while (0)
-
 static void *_opcode_stats_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct qib_opcode_stats_perctx *opstats;
@@ -249,17 +240,16 @@ DEBUGFS_FILE(qp_stats)
 
 void qib_dbg_ibdev_init(struct qib_ibdev *ibd)
 {
+	struct dentry *root;
 	char name[10];
 
 	snprintf(name, sizeof(name), "qib%d", dd_from_dev(ibd)->unit);
-	ibd->qib_ibdev_dbg = debugfs_create_dir(name, qib_dbg_root);
-	if (!ibd->qib_ibdev_dbg) {
-		pr_warn("create of %s failed\n", name);
-		return;
-	}
-	DEBUGFS_FILE_CREATE(opcode_stats);
-	DEBUGFS_FILE_CREATE(ctx_stats);
-	DEBUGFS_FILE_CREATE(qp_stats);
+	root = debugfs_create_dir(name, qib_dbg_root);
+	ibd->qib_ibdev_dbg = root;
+
+	debugfs_create_file("opcode_stats", 0400, root, ibd, &_opcode_stats_file_ops);
+	debugfs_create_file("ctx_stats", 0400, root, ibd, &_ctx_stats_file_ops);
+	debugfs_create_file("qp_stats", 0400, root, ibd, &_qp_stats_file_ops);
 }
 
 void qib_dbg_ibdev_exit(struct qib_ibdev *ibd)
@@ -274,8 +264,6 @@ void qib_dbg_ibdev_exit(struct qib_ibdev *ibd)
 void qib_dbg_init(void)
 {
 	qib_dbg_root = debugfs_create_dir(QIB_DRV_NAME, NULL);
-	if (!qib_dbg_root)
-		pr_warn("init of debugfs failed\n");
 }
 
 void qib_dbg_exit(void)
-- 
2.20.1
