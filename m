From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 01/10] IB/iser: Fix module init not cleaning up on error flow
Date: Tue, 24 Nov 2015 18:23:45 +0200
Message-ID: <1448382234-24806-2-git-send-email-sagig@mellanox.com>
References: <1448382234-24806-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448382234-24806-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Destroy workqueue on transport register error, also
release kmem cache on workqueue alloc error.

Signed-off-by: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 9080161e01af..5e6c0bf1e84b 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -1059,7 +1059,8 @@ static int __init iser_init(void)
 	release_wq = alloc_workqueue("release workqueue", 0, 0);
 	if (!release_wq) {
 		iser_err("failed to allocate release workqueue\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_alloc_wq;
 	}
 
 	iscsi_iser_scsi_transport = iscsi_register_transport(
@@ -1067,12 +1068,14 @@ static int __init iser_init(void)
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
