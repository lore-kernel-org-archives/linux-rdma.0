From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] infiniband: remove redundant condition check before debugfs_remove
Date: Sat, 8 Sep 2018 21:49:31 +0800
Message-ID: <1536414571-32675-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, benve@cisco.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

debugfs_remove has taken the IS_ERR_OR_NULL into account. Just
remove the unnecessary condition.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/infiniband/hw/usnic/usnic_debugfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infiniband/hw/usnic/usnic_debugfs.c
index 92dc66c..a311570 100644
--- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
@@ -165,6 +165,5 @@ void usnic_debugfs_flow_add(struct usnic_ib_qp_grp_flow *qp_flow)
 
 void usnic_debugfs_flow_remove(struct usnic_ib_qp_grp_flow *qp_flow)
 {
-	if (!IS_ERR_OR_NULL(qp_flow->dbgfs_dentry))
-		debugfs_remove(qp_flow->dbgfs_dentry);
+	debugfs_remove(qp_flow->dbgfs_dentry);
 }
-- 
1.7.12.4
