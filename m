From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH] infiniband: nes: add unlikely() to assert()
Date: Fri, 31 Aug 2018 22:24:18 +0300
Message-ID: <20180831192418.12346-1-igor.stoppa@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>
Cc: igor.stoppa@gmail.com, Igor Stoppa <igor.stoppa@huawei.com>, Chien Tung <chien.tin.tung@intel.com>, Roland Dreier <rolandd@cisco.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Typically the assert is expected to not fail.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
Acked-by: Doug Ledford <dledford@redhat.com>
Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Chien Tung <chien.tin.tung@intel.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/infiniband/hw/nes/nes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index bedaa02749fb..d2d0098f38e0 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -151,7 +151,7 @@ do { \
 
 #define assert(expr) \
 do { \
-	if (!(expr)) { \
+	if (unlikely(!(expr))) { \
 		printk(KERN_ERR PFX "Assertion failed! %s, %s, %s, line %d\n", \
 			   #expr, __FILE__, __func__, __LINE__); \
 	} \
-- 
2.17.1
