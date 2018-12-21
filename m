From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] IB/qib: Add missing err handle for qib_user_sdma_rb_insert
Date: Fri, 21 Dec 2018 10:19:38 +0800
Message-ID: <20181221021938.13784-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: dennis.dalessandro@intel.com, mike.marciniszyn@intel.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-rdma@vger.kernel.org

It should goto err handle if qib_user_sdma_rb_insert fails,
other than success return.

Fixes: 67810e8c3c01 ("RDMA/qib: Remove all occurrences of BUG_ON()")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 31c523b..e87c0a7 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -237,6 +237,8 @@ qib_user_sdma_queue_create(struct device *dev, int unit, int ctxt, int sctxt)
 
 		ret = qib_user_sdma_rb_insert(&qib_user_sdma_rb_root,
 					sdma_rb_node);
+		if (ret == 0)
+			goto err_rb;
 	}
 	pq->sdma_rb_node = sdma_rb_node;
 
-- 
2.7.0
