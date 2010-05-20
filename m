From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 01/11] RDMA/cxgb4: Detach from the LLD after unregistering
	with the RDMA core.
Date: Thu, 20 May 2010 16:57:27 -0500
Message-ID: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

In the RDMA core unregister path, kernel users will be calling down
into the T4 provider to release resources.  So we cannot detach from
the LLD until this process completes.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/device.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index be23b5e..c7e2484 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -504,14 +504,12 @@ static void __exit c4iw_exit_module(void)
 {
 	struct c4iw_dev *dev, *tmp;
 
-	cxgb4_unregister_uld(CXGB4_ULD_RDMA);
-
 	mutex_lock(&dev_mutex);
 	list_for_each_entry_safe(dev, tmp, &dev_list, entry) {
 		c4iw_remove(dev);
 	}
 	mutex_unlock(&dev_mutex);
-
+	cxgb4_unregister_uld(CXGB4_ULD_RDMA);
 	c4iw_cm_term();
 	debugfs_remove_recursive(c4iw_debugfs_root);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
