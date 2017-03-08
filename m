From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 17/26] IB/ocrdma: Use kmalloc_array() in ocrdma_create_srq()
Date: Wed, 8 Mar 2017 14:17:29 +0100
Message-ID: <b621d28f-08b5-8d4a-e6ea-b1208f10bb85@users.sourceforge.net>
References: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <fc421509-4069-da8a-b308-60b49ea91ada@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Devesh Sharma <devesh.sharma@avagotech.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Selvin Xavier <selvin.xavier@avagotech.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 8 Mar 2017 08:45:31 +0100

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of a data type by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index bc9fb144e57b..ef670ac1cbe9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1910,8 +1910,9 @@ struct ib_srq *ocrdma_create_srq(struct ib_pd *ibpd,
 
 		srq->bit_fields_len = (srq->rq.max_cnt / 32) +
 		    (srq->rq.max_cnt % 32 ? 1 : 0);
-		srq->idx_bit_fields =
-		    kmalloc(srq->bit_fields_len * sizeof(u32), GFP_KERNEL);
+		srq->idx_bit_fields = kmalloc_array(srq->bit_fields_len,
+						    sizeof(*srq->idx_bit_fields),
+						    GFP_KERNEL);
 		if (srq->idx_bit_fields == NULL)
 			goto arm_err;
 		memset(srq->idx_bit_fields, 0xff,
-- 
2.12.0

