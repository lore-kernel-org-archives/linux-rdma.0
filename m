From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-next 01/10] IB/iser: Fix module init not cleaning up on error flow
Date: Mon, 16 Nov 2015 18:37:32 +0200
Message-ID: <1447691861-3796-2-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, Roi Dayan <roid@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

destroy workqueue on transport register error
release kmem cache on workqueue alloc error

Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 8017f3a049fb..f1ddad34b001 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -1063,7 +1063,8 @@ static int __init iser_init(void)
 	release_wq = alloc_workqueue("release workqueue", 0, 0);
 	if (!release_wq) {
 		iser_err("failed to allocate release workqueue\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_alloc_wq;
 	}
 
 	iscsi_iser_scsi_transport = iscsi_register_transport(
@@ -1071,12 +1072,14 @@ static int __init iser_init(void)
 	if (!iscsi_iser_scsi_transport) {
 		iser_err("iscsi_register_transport failed\n");
 		err = -EINVAL;
-		goto register_transport_failure;
+		goto err_reg;
 	}
 
 	return 0;
 
-register_transport_failure:
+err_reg:
+	destroy_workqueue(release_wq);
+err_alloc_wq:
 	kmem_cache_destroy(ig.desc_cache);
 
 	return err;
-- 
1.8.4.3
