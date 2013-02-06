From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 45/77] IB/ocrdma: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:17 -0800
Message-ID: <1360179649-22465-46-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Roland Dreier <roland@purestorage.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index c4e0131..48928c8 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -51,18 +51,6 @@ static DEFINE_IDR(ocrdma_dev_id);
 
 static union ib_gid ocrdma_zero_sgid;
 
-static int ocrdma_get_instance(void)
-{
-	int instance = 0;
-
-	/* Assign an unused number */
-	if (!idr_pre_get(&ocrdma_dev_id, GFP_KERNEL))
-		return -1;
-	if (idr_get_new(&ocrdma_dev_id, NULL, &instance))
-		return -1;
-	return instance;
-}
-
 void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 {
 	u8 mac_addr[6];
@@ -416,7 +404,7 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 		goto idr_err;
 
 	memcpy(&dev->nic_info, dev_info, sizeof(*dev_info));
-	dev->id = ocrdma_get_instance();
+	dev->id = idr_alloc(&ocrdma_dev_id, NULL, 0, 0, GFP_KERNEL);
 	if (dev->id < 0)
 		goto idr_err;
 
-- 
1.8.1
