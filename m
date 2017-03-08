From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 06/26] IB/ocrdma: Improve another size determination in
 ocrdma_alloc_pd_pool()
Date: Wed, 8 Mar 2017 13:53:17 +0100
Message-ID: <00537ca7-1c89-b1a0-8faf-eb1c65a114ec@users.sourceforge.net>
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
Date: Tue, 7 Mar 2017 19:54:38 +0100

Replace the specification of a data structure by a pointer dereference
as the parameter for the operator "sizeof" to make the corresponding size
determination a bit safer according to the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index 8122a1c7d2ae..56f29e06dfe4 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1595,8 +1595,7 @@ void ocrdma_alloc_pd_pool(struct ocrdma_dev *dev)
 {
 	int status;
 
-	dev->pd_mgr = kzalloc(sizeof(struct ocrdma_pd_resource_mgr),
-			      GFP_KERNEL);
+	dev->pd_mgr = kzalloc(sizeof(*dev->pd_mgr), GFP_KERNEL);
 	if (!dev->pd_mgr)
 		return;
 
-- 
2.12.0
