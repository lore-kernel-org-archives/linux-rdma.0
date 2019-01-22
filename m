From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/8] infiniband: hfi1: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:17:55 +0100
Message-ID: <20190122151800.15092-4-gregkh@linuxfoundation.org>
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
 drivers/infiniband/hw/hfi1/debugfs.c |  2 --
 drivers/infiniband/hw/hfi1/fault.c   | 50 ++++++++++------------------
 2 files changed, 18 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/debugfs.c b/drivers/infiniband/hw/hfi1/debugfs.c
index 52c00c67056f..961009e66047 100644
--- a/drivers/infiniband/hw/hfi1/debugfs.c
+++ b/drivers/infiniband/hw/hfi1/debugfs.c
@@ -1335,8 +1335,6 @@ DEBUGFS_FILE_OPS(driver_stats);
 void hfi1_dbg_init(void)
 {
 	hfi1_dbg_root  = debugfs_create_dir(DRIVER_NAME, NULL);
-	if (!hfi1_dbg_root)
-		pr_warn("init of debugfs failed\n");
 	debugfs_create_file("driver_stats_names", 0444, hfi1_dbg_root, NULL, &_driver_stats_names_file_ops);
 	debugfs_create_file("driver_stats", 0444, hfi1_dbg_root, NULL, &_driver_stats_file_ops);
 }
diff --git a/drivers/infiniband/hw/hfi1/fault.c b/drivers/infiniband/hw/hfi1/fault.c
index dd09b8544568..195fe81e13ea 100644
--- a/drivers/infiniband/hw/hfi1/fault.c
+++ b/drivers/infiniband/hw/hfi1/fault.c
@@ -250,6 +250,7 @@ void hfi1_fault_exit_debugfs(struct hfi1_ibdev *ibd)
 int hfi1_fault_init_debugfs(struct hfi1_ibdev *ibd)
 {
 	struct dentry *parent = ibd->hfi1_ibdev_dbg;
+	struct dentry *fault_dir;
 
 	ibd->fault = kzalloc(sizeof(*ibd->fault), GFP_KERNEL);
 	if (!ibd->fault)
@@ -269,46 +270,31 @@ int hfi1_fault_init_debugfs(struct hfi1_ibdev *ibd)
 	bitmap_zero(ibd->fault->opcodes,
 		    sizeof(ibd->fault->opcodes) * BITS_PER_BYTE);
 
-	ibd->fault->dir =
-		fault_create_debugfs_attr("fault", parent,
-					  &ibd->fault->attr);
-	if (IS_ERR(ibd->fault->dir)) {
+	fault_dir = fault_create_debugfs_attr("fault", parent,
+					      &ibd->fault->attr);
+	if (IS_ERR(fault_dir)) {
 		kfree(ibd->fault);
 		ibd->fault = NULL;
 		return -ENOENT;
 	}
+	ibd->fault->dir = fault_dir;
 
-	debugfs_create_file("fault_stats", 0444, ibd->fault->dir, ibd,
+	debugfs_create_file("fault_stats", 0444, fault_dir, ibd,
 			    &_fault_stats_file_ops);
-	if (!debugfs_create_bool("enable", 0600, ibd->fault->dir,
-				 &ibd->fault->enable))
-		goto fail;
-	if (!debugfs_create_bool("suppress_err", 0600,
-				 ibd->fault->dir,
-				 &ibd->fault->suppress_err))
-		goto fail;
-	if (!debugfs_create_bool("opcode_mode", 0600, ibd->fault->dir,
-				 &ibd->fault->opcode))
-		goto fail;
-	if (!debugfs_create_file("opcodes", 0600, ibd->fault->dir,
-				 ibd->fault, &__fault_opcodes_fops))
-		goto fail;
-	if (!debugfs_create_u64("skip_pkts", 0600,
-				ibd->fault->dir,
-				&ibd->fault->fault_skip))
-		goto fail;
-	if (!debugfs_create_u64("skip_usec", 0600,
-				ibd->fault->dir,
-				&ibd->fault->fault_skip_usec))
-		goto fail;
-	if (!debugfs_create_u8("direction", 0600, ibd->fault->dir,
-			       &ibd->fault->direction))
-		goto fail;
+	debugfs_create_bool("enable", 0600, fault_dir, &ibd->fault->enable);
+	debugfs_create_bool("suppress_err", 0600, fault_dir,
+			    &ibd->fault->suppress_err);
+	debugfs_create_bool("opcode_mode", 0600, fault_dir,
+			    &ibd->fault->opcode);
+	debugfs_create_file("opcodes", 0600, fault_dir, ibd->fault,
+			    &__fault_opcodes_fops);
+	debugfs_create_u64("skip_pkts", 0600, fault_dir,
+			   &ibd->fault->fault_skip);
+	debugfs_create_u64("skip_usec", 0600, fault_dir,
+			   &ibd->fault->fault_skip_usec);
+	debugfs_create_u8("direction", 0600, fault_dir, &ibd->fault->direction);
 
 	return 0;
-fail:
-	hfi1_fault_exit_debugfs(ibd);
-	return -ENOMEM;
 }
 
 bool hfi1_dbg_fault_suppress_err(struct hfi1_ibdev *ibd)
-- 
2.20.1
