From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 16/26] IB/ocrdma: Adjust a null pointer check in
 ocrdma_alloc_resources()
Date: Wed, 8 Mar 2017 14:15:34 +0100
Message-ID: <54750756-91cd-b508-109a-83b7b2375193@users.sourceforge.net>
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
Date: Tue, 7 Mar 2017 22:34:33 +0100

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written "!dev->stag_arr".

Thus fix the affected source code place.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 93113feeb2d5..fbf672c79d5f 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -238,7 +238,7 @@ static int ocrdma_alloc_resources(struct ocrdma_dev *dev)
 
 	dev->stag_arr = kcalloc(OCRDMA_MAX_STAG, sizeof(*dev->stag_arr),
 				GFP_KERNEL);
-	if (dev->stag_arr == NULL)
+	if (!dev->stag_arr)
 		goto alloc_err;
 
 	ocrdma_alloc_pd_pool(dev);
-- 
2.12.0
