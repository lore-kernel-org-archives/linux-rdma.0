From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 7/8] infiniband: usnic: no need to check return value of debugfs_create functions
Date: Tue, 22 Jan 2019 16:17:59 +0100
Message-ID: <20190122151800.15092-8-gregkh@linuxfoundation.org>
References: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190122151800.15092-1-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christian Benvenuti <benve@cisco.com>, Nelson Escobar <neescoba@cisco.com>, Parvi Kaustubhi <pkaustub@cisco.com>
List-Id: linux-rdma@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Christian Benvenuti <benve@cisco.com>
Cc: Nelson Escobar <neescoba@cisco.com>
Cc: Parvi Kaustubhi <pkaustub@cisco.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/usnic/usnic_debugfs.c | 26 ---------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index a3115709fb03..e5a3f02fb078 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -113,42 +113,21 @@ static const struct file_operations flowinfo_ops = {
 void usnic_debugfs_init(void)
 {
 	debugfs_root = debugfs_create_dir(DRV_NAME, NULL);
-	if (IS_ERR(debugfs_root)) {
-		usnic_err("Failed to create debugfs root dir, check if debugfs is enabled in kernel configuration\n");
-		goto out_clear_root;
-	}
 
 	flows_dentry = debugfs_create_dir("flows", debugfs_root);
-	if (IS_ERR_OR_NULL(flows_dentry)) {
-		usnic_err("Failed to create debugfs flow dir with err %ld\n",
-				PTR_ERR(flows_dentry));
-		goto out_free_root;
-	}
 
 	debugfs_create_file("build-info", S_IRUGO, debugfs_root,
 				NULL, &usnic_debugfs_buildinfo_ops);
-	return;
-
-out_free_root:
-	debugfs_remove_recursive(debugfs_root);
-out_clear_root:
-	debugfs_root = NULL;
 }
 
 void usnic_debugfs_exit(void)
 {
-	if (!debugfs_root)
-		return;
-
 	debugfs_remove_recursive(debugfs_root);
 	debugfs_root = NULL;
 }
 
 void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_flow *qp_flow)
 {
-	if (IS_ERR_OR_NULL(flows_dentry))
-		return;
-
 	scnprintf(qp_flow->dentry_name, sizeof(qp_flow->dentry_name),
 			"%u", qp_flow->flow->flow_id);
 	qp_flow->dbgfs_dentry = debugfs_create_file(qp_flow->dentry_name,
@@ -156,11 +135,6 @@ void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_flow *qp_flow)
 							flows_dentry,
 							qp_flow,
 							&flowinfo_ops);
-	if (IS_ERR_OR_NULL(qp_flow->dbgfs_dentry)) {
-		usnic_err("Failed to create dbg fs entry for flow %u with error %ld\n",
-				qp_flow->flow->flow_id,
-				PTR_ERR(qp_flow->dbgfs_dentry));
-	}
 }
 
 void usnic_debugfs_flow_remove(struct usnic_ib_qp_grp_flow *qp_flow)
-- 
2.20.1
