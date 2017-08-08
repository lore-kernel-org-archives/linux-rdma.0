From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] IB/hns: fix memory leak on ah on error return path
Date: Tue,  8 Aug 2017 18:41:02 +0100
Message-ID: <20170808174102.28568-1-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

When dmac is NULL, ah is not being freed on the error return path. Fix
this by kfree'ing it.

Detected by CoverityScan, CID#1452636 ("Resource Leak")

Fixes: d8966fcd4c25 ("IB/core: Use rdma_ah_attr accessor functions")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/hw/hns/hns_roce_ah.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_ah.c b/drivers/infiniband/hw/hns/hns_roce_ah.c
index f78a733a63ec..d545302b8ef8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_ah.c
+++ b/drivers/infiniband/hw/hns/hns_roce_ah.c
@@ -64,8 +64,10 @@ struct ib_ah *hns_roce_create_ah(struct ib_pd *ibpd,
 	} else {
 		u8 *dmac = rdma_ah_retrieve_dmac(ah_attr);
 
-		if (!dmac)
+		if (!dmac) {
+			kfree(ah);
 			return ERR_PTR(-EINVAL);
+		}
 		memcpy(ah->av.mac, dmac, ETH_ALEN);
 	}
 
-- 
2.11.0
