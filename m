From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 01/26] IB/ocrdma: Use kcalloc() in ocrdma_create_eqs()
Date: Wed, 8 Mar 2017 13:36:53 +0100
Message-ID: <c96d5d88-fcee-26c5-4b01-8a12f6f46561@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 7 Mar 2017 17:56:45 +0100

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus reuse the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index aa6967197620..cbac41b15d94 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -3103,7 +3103,7 @@ static int ocrdma_create_eqs(struct ocrdma_dev *dev)
 	if (!num_eq)
 		return -EINVAL;
 
-	dev->eq_tbl = kzalloc(sizeof(struct ocrdma_eq) * num_eq, GFP_KERNEL);
+	dev->eq_tbl = kcalloc(num_eq, sizeof(*dev->eq_tbl), GFP_KERNEL);
 	if (!dev->eq_tbl)
 		return -ENOMEM;
 
-- 
2.12.0
