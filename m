From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/5] IB/hfi1: Use kcalloc() in hfi1_user_sdma_alloc_queues()
Date: Fri, 10 Feb 2017 22:02:19 +0100
Message-ID: <71be9ebc-950f-7af2-4044-2c4b1ee44281@users.sourceforge.net>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Sean Hefty <sean.hefty@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 9 Feb 2017 16:06:12 +0100

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus reuse the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/hfi1/user_sdma.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 7d22f8ee98ef..15194554a92b 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -400,13 +400,15 @@ int hfi1_user_sdma_alloc_queues(struct hfi1_ctxtdata *uctxt, struct file *fp)
 	if (!pq)
 		goto pq_nomem;
 
-	memsize = sizeof(*pq->reqs) * hfi1_sdma_comp_ring_size;
-	pq->reqs = kzalloc(memsize, GFP_KERNEL);
+	pq->reqs = kcalloc(hfi1_sdma_comp_ring_size,
+			   sizeof(*pq->reqs),
+			   GFP_KERNEL);
 	if (!pq->reqs)
 		goto pq_reqs_nomem;
 
-	memsize = BITS_TO_LONGS(hfi1_sdma_comp_ring_size) * sizeof(long);
-	pq->req_in_use = kzalloc(memsize, GFP_KERNEL);
+	pq->req_in_use = kcalloc(BITS_TO_LONGS(hfi1_sdma_comp_ring_size),
+				 sizeof(*pq->req_in_use),
+				 GFP_KERNEL);
 	if (!pq->req_in_use)
 		goto pq_reqs_no_in_use;
 
-- 
2.11.1
