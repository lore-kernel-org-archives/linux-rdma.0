From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: [PATCH 2/2] RDMA/ocrdma: update module license to dual license
Date: Fri, 12 Jun 2015 22:15:05 +0530
Message-ID: <1434127505-17739-3-git-send-email-devesh.sharma@avagotech.com>
References: <1434127505-17739-1-git-send-email-devesh.sharma@avagotech.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434127505-17739-1-git-send-email-devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch updates the ocrdma module license from GPL to
Dual BSD/GPL licensing.

Signed-off-by: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index cee43c1..2917324 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -60,7 +60,7 @@
 MODULE_VERSION(OCRDMA_ROCE_DRV_VERSION);
 MODULE_DESCRIPTION(OCRDMA_ROCE_DRV_DESC " " OCRDMA_ROCE_DRV_VERSION);
 MODULE_AUTHOR("Emulex Corporation");
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("Dual BSD/GPL");
 
 static LIST_HEAD(ocrdma_dev_list);
 static DEFINE_SPINLOCK(ocrdma_devlist_lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
