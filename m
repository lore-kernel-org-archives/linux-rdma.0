From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] RDMA/cxgb4: remove accidentally left mutex_unlock(&dev_mutex)
Date: Thu,  1 Sep 2011 00:43:30 +0400
Message-ID: <1314823410-12621-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@ispras.ru
List-Id: linux-rdma@vger.kernel.org

The patch "RDMA/cxgb4: EEH errors can hang the driver" removes
mutex lock/unlock from c4iw_alloc() except for error path.
This patch removes the remained mutex_unlock(&dev_mutex).

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/infiniband/hw/cxgb4/device.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 40a13cc..35896ff 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -414,7 +414,6 @@ static struct c4iw_dev *c4iw_alloc(const struct cxgb4_lld_info *infop)
 
 	ret = c4iw_rdev_open(&devp->rdev);
 	if (ret) {
-		mutex_unlock(&dev_mutex);
 		printk(KERN_ERR MOD "Unable to open CXIO rdev err %d\n", ret);
 		ib_dealloc_device(&devp->ibdev);
 		return ERR_PTR(ret);
-- 
1.7.4.1
