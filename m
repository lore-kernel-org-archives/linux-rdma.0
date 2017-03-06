From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/5] IB/nes: Use kcalloc() in nes_init_mgt_qp()
Date: Mon, 6 Mar 2017 18:40:13 +0100
Message-ID: <c7ce5066-0466-209e-883b-677768c771a4@users.sourceforge.net>
References: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <502a5a6f-ee91-dd2f-cdc7-63f396059529@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Faisal Latif <faisal.latif@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 6 Mar 2017 16:07:41 +0100

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus reuse the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/nes/nes_mgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 33624f17c347..a84fffd33c21 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -877,7 +877,7 @@ int nes_init_mgt_qp(struct nes_device *nesdev, struct net_device *netdev, struct
 	int ret;
 
 	/* Allocate space the all mgt QPs once */
-	mgtvnic = kzalloc(NES_MGT_QP_COUNT * sizeof(struct nes_vnic_mgt), GFP_KERNEL);
+	mgtvnic = kcalloc(NES_MGT_QP_COUNT, sizeof(*mgtvnic), GFP_KERNEL);
 	if (!mgtvnic)
 		return -ENOMEM;
 
-- 
2.12.0
